{ pkgs, ... }:

let
  python = pkgs.python313.withPackages (ps: [
    ps.notion-client
  ]);
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "notion";
      runtimeInputs = [ python ];
      text = ''
        exec python - "$@" <<'PY'
        import json
        import os
        import sys
        from notion_client import Client


        def usage():
            print("usage:")
            print("  notion search <query>")
            print("  notion db <database-id>")
            print("  notion page <page-id>")
            print("")
            print("requires: export NOTION_TOKEN=secret_xxx")


        def plain_text(rich_text):
            return "".join(part.get("plain_text", "") for part in rich_text or [])


        def title_for(obj):
            props = obj.get("properties", {})
            for prop in props.values():
                if prop.get("type") == "title":
                    return plain_text(prop.get("title"))
            return obj.get("title", [{}])[0].get("plain_text", "") if obj.get("title") else ""


        token = os.environ.get("NOTION_TOKEN")
        if not token:
            print("Set NOTION_TOKEN first", file=sys.stderr)
            sys.exit(1)

        notion = Client(auth=token)
        cmd = sys.argv[1] if len(sys.argv) > 1 else None

        if cmd == "search" and len(sys.argv) > 2:
            query = " ".join(sys.argv[2:])
            res = notion.search(query=query)
            for item in res["results"]:
                title = title_for(item) or "(untitled)"
                obj = item["object"]
                item_id = item["id"]
                url = item.get("url", "")
                print(f"{obj}\t{title}\t{item_id}\t{url}")

        elif cmd == "db" and len(sys.argv) == 3:
            res = notion.databases.query(database_id=sys.argv[2])
            print(json.dumps(res, indent=2))

        elif cmd == "page" and len(sys.argv) == 3:
            res = notion.pages.retrieve(page_id=sys.argv[2])
            print(json.dumps(res, indent=2))

        else:
            usage()
            sys.exit(2)
        PY
      '';
    })
  ];
}
