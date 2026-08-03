{
  pkgs,
  ...
}:
let
  wt = pkgs.writeShellApplication {
    name = "wt";
    runtimeInputs = with pkgs; [
      git
      coreutils
      gnused
    ];
    text = ''
      slots=(alpha bravo charlie delta echo foxtrot golf)
      cmd="''${1:-help}"

      configure() {
        org="''${WT_ORG:-}"
        repo="''${WT_REPO:-}"
        if [[ -z "$org" || -z "$repo" ]]; then
          echo "Set WT_ORG and WT_REPO before using wt" >&2
          exit 1
        fi
        if [[ "$org" == */* || "$repo" == */* ]]; then
          echo "WT_ORG and WT_REPO must be names, not paths" >&2
          exit 1
        fi
        base="$HOME/github.com/$org"
      }

      slot_dir() {
        printf '%s/%s_%s\n' "$base" "$repo" "$1"
      }

      case "$cmd" in
        status|st|s)
          configure
          shift 2>/dev/null || true
          detail=false
          target=""
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --detail|-d) detail=true; shift ;;
              *) target="$1"; shift ;;
            esac
          done

          if [[ -n "$target" ]]; then
            dir=$(slot_dir "$target")
            if [[ ! -d "$dir" ]]; then
              echo "Slot $target not found"
              exit 1
            fi
            branch=$(git -C "$dir" branch --show-current 2>/dev/null)
            dirty=$(git -C "$dir" status --porcelain 2>/dev/null | head -1)
            last=$(git -C "$dir" log -1 --format='%cr' 2>/dev/null)
            if [[ "$branch" == "dev" ]] && [[ -z "$dirty" ]]; then
              printf "\033[32m%-10s\033[0m free  \033[2m%s\033[0m\n" "$target" "$last"
            else
              label="$branch"
              [[ -n "$dirty" ]] && label="$label \033[31m*\033[0m"
              printf "\033[33m%-10s\033[0m %b  \033[2m%s\033[0m\n" "$target" "$label" "$last"
            fi
            echo ""
            git -C "$dir" status --short 2>/dev/null
            echo ""
            git -C "$dir" log --oneline -5 2>/dev/null
            exit 0
          fi

          tmpdir=$(mktemp -d)
          set -m # enable job control for background subshells
          for slot in "''${slots[@]}"; do
            dir=$(slot_dir "$slot")
            [[ ! -d "$dir" ]] && continue
            (
              branch=$(git -C "$dir" branch --show-current 2>/dev/null)
              dirty=$(git -C "$dir" status --porcelain 2>/dev/null | head -1)
              last=$(git -C "$dir" log -1 --format='%cr' 2>/dev/null)
              if [[ "$branch" == "dev" ]] && [[ -z "$dirty" ]]; then
                printf "\033[32m%-10s\033[0m free  \033[2m%s\033[0m\n" "$slot" "$last"
              else
                label="$branch"
                [[ -n "$dirty" ]] && label="$label \033[31m*\033[0m"
                printf "\033[33m%-10s\033[0m %b  \033[2m%s\033[0m\n" "$slot" "$label" "$last"
              fi
              if $detail; then
                git -C "$dir" status --short 2>/dev/null | sed 's/^/           /'
              fi
            ) > "$tmpdir/$slot" &
          done
          wait
          set +m
          for slot in "''${slots[@]}"; do
            [[ -f "$tmpdir/$slot" ]] && cat "$tmpdir/$slot"
          done
          rm -rf "$tmpdir"
          ;;
        free)
          configure
          for slot in "''${slots[@]}"; do
            dir=$(slot_dir "$slot")
            [[ ! -d "$dir" ]] && continue
            branch=$(git -C "$dir" branch --show-current 2>/dev/null)
            dirty=$(git -C "$dir" status --porcelain 2>/dev/null | head -1)
            if [[ "$branch" == "dev" ]] && [[ -z "$dirty" ]]; then
              if ! git -C "$dir" checkout dev; then
                echo "Unable to prepare $slot" >&2
                exit 1
              fi
              if ! git -C "$dir" pull --ff-only; then
                echo "Unable to update $slot from origin/dev" >&2
                exit 1
              fi
              echo "-> $slot"
              echo "$dir"
              exit 0
            fi
          done
          echo "No free slots available"
          exit 1
          ;;
        release|rel)
          configure
          # Detect which configured repository slot we're in from cwd.
          current="''${PWD##*/}"
          slot_name=""
          for slot in "''${slots[@]}"; do
            if [[ "$current" == "$repo"_"$slot" ]]; then
              slot_name="$slot"
              break
            fi
          done
          if [[ -z "$slot_name" ]]; then
            echo "Not in a worktree slot"
            exit 1
          fi
          if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
            echo "Dirty working tree — stash or commit first"
            exit 1
          fi
          if ! git checkout dev; then
            echo "Unable to release $slot_name: dev may already be checked out in a linked worktree" >&2
            exit 1
          fi
          if ! git pull --ff-only; then
            echo "Unable to update $slot_name from origin/dev" >&2
            exit 1
          fi
          echo "<- $slot_name released"
          ;;
        alpha|bravo|charlie|delta|echo|foxtrot|golf)
          configure
          dir=$(slot_dir "$cmd")
          if [[ -d "$dir" ]]; then
            echo "$dir"
          else
            echo "Slot $cmd not found"
            exit 1
          fi
          ;;
        help|-h|--help|*)
          cat <<'HELP'
      wt - manage repository worktree slots

        wt                      Show this help
        wt s|status             Overview of all slots (with last modified)
        wt s|status <name>      Detail for a specific slot (changes + recent commits)
        wt s|status --detail    Detail for all slots
        wt free                 cd into first free slot, checkout dev, pull
        wt rel|release          Release current slot (checkout dev, pull)
        wt <name>               cd into a specific slot

      Environment:
        WT_ORG                  GitHub organization under ~/github.com
        WT_REPO                 Repository name used by <repo>_<slot> directories
      HELP
          ;;
      esac
    '';
  };
in
{
  home.packages = [ wt ];

  # Shell wrapper: commands that need cd (free, slot names) must run in the
  # current shell. The wt executable prints the target dir as its last line;
  # these functions cd into it instead of leaving the path as plain output.
  programs.zsh.initContent = ''
    function wt() {
      local cmd="''${1:-help}"
      case "$cmd" in
        free|alpha|bravo|charlie|delta|echo|foxtrot|golf)
          local output rc dir
          output=$(command wt "$@")
          rc=$?
          dir=$(printf '%s\n' "$output" | tail -n 1)
          if [[ $rc -eq 0 && -d "$dir" ]]; then
            printf '%s\n' "$output" | sed '$d'
            cd "$dir" || return 1
          else
            printf '%s\n' "$output"
            return "$rc"
          fi
          ;;
        *)
          command wt "$@"
          ;;
      esac
    }
  '';

  programs.bash.initExtra = ''
    wt() {
      local cmd="''${1:-help}"
      case "$cmd" in
        free|alpha|bravo|charlie|delta|echo|foxtrot|golf)
          local output rc dir
          output=$(command wt "$@")
          rc=$?
          dir=$(printf '%s\n' "$output" | tail -n 1)
          if [[ $rc -eq 0 && -d "$dir" ]]; then
            printf '%s\n' "$output" | sed '$d'
            cd "$dir" || return 1
          else
            printf '%s\n' "$output"
            return "$rc"
          fi
          ;;
        *)
          command wt "$@"
          ;;
      esac
    }
  '';
}
