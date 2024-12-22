import * as path from "path";
import type { Definition, Link, Image, Root } from "mdast";
import { visit } from "unist-util-visit";

/** Remark plugin to prepend a path in front of relative link hrefs. */
export function prefixLinks({ base }: { base: string }) {
    // Make sure the base path has a trailing slash.
    if (!base.endsWith("/")) base = base + "/";

    return function remarkPlugin() {
        return function transform(tree: Root, file: any) {
            const fileDirname = file.dirname as string;

            function visitor(node: Link | Definition | Image) {
                // Ignore remote links
                if (node.url.startsWith("http")) return console.info(`[CorrectURL] ignore remote URL: ${node.url}`);

                var resolvedRaw = path.resolve(fileDirname, node.url).split("src/content/docs");
                var resolved = resolvedRaw.length > 1 ? resolvedRaw[resolvedRaw.length - 1] : resolvedRaw[0];

                const relativeUrl = resolved.replace(/^.?\//, "").replace(/\.(mdx|md)/, "");

                console.info(`[CorrectURL] fix ${node.url} -> ${"/" + relativeUrl}`);

                // Prefix with base path if it was a bare link (not an asset)
                node.url = base + relativeUrl + (!(/\/[^\/]+\.[a-zA-Z0-9]+$/).test(relativeUrl) ? "/" : "");
            }
            // Apply our visitor to Markdown links, including definition links
            visit(tree, "image", visitor);
            visit(tree, "link", visitor);
            visit(tree, "definition", visitor);
            // Also prefix base to links written with HTML syntax (<a>)
            visit(tree, "html", function htmlVisitor(node) {
                node.value = node.value.replace(
                    /(?<=href=")(?!https?:\/\/)\/?(.+)(?=")/g,
                    `${base}$1`
                );
            });
        };
    };
}
