// @ts-check
import starlightSidebarTopics from "starlight-sidebar-topics";
import starlightPydocs, { pydocsSidebarGroup } from 'starlight-pydocs';
import { prefixLinks } from "./src/plugins/CorrectURL";
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import tailwind from "@tailwindcss/vite";
import react from "@astrojs/react";
import fs from "fs";

var SITE_URL;
fs.readFile("./public/CNAME", "utf-8", (err, data) => {
  if (err) {
    return;
  }

  SITE_URL = data.trim();
});
const BASE_URL = "";


// https://astro.build/config
export default defineConfig({
  base: BASE_URL,
  site: SITE_URL,
  trailingSlash: "ignore",

  markdown: {
    remarkPlugins: [prefixLinks({ base: BASE_URL + "/" })],
  },

  integrations: [
    starlight({
      title: "Fabric",
      plugins: [
        starlightSidebarTopics([
          {
            label: "Guides",
            link: "/getting-started/introduction/",
            icon: "open-book",
            items: [
              {
                label: "Getting Started",
                items: [{ autogenerate: { directory: "getting-started" } }],
              },
              {
                label: "Guide",
                items: [{ autogenerate: { directory: "guide" } }],
              },
              {
                label: "Community Snippets",
                items: [{ autogenerate: { directory: "snippets" } }],
              },
              {
                label: "Contributing",
                items: [{ autogenerate: { directory: "contributing" } }],
                collapsed: true,
              },
            ],
          },
          {
            label: "API Reference",
            link: "/api/fabric/",
            icon: "information",
            items: [
              {
                label: "Parent Package",
                items: [{ autogenerate: { directory: "api" } }],
              },
            ],
          },
        ]),
        // starlightPydocs({
        //   packages: [{ name: "fabric", search: ["./.ignore-me-fabric-tmp"], docstringStyle: "sphinx" }],
        // }),
      ],
      // sidebar: [{ label: 'API reference', items: [pydocsSidebarGroup] }],

      editLink: {
        baseUrl: "https://github.com/Fabric-Development/fabric-wiki/edit/",
      },
      logo: {
        dark: "./src/assets/logo-dark.svg",
        light: "./src/assets/logo-light.svg",
        replacesTitle: false,
      },
      social: [
        {
          icon: "github",
          label: "GitHub",
          href: "https://github.com/Fabric-Development/fabric",
        },
        {
          icon: "discord",
          label: "Discord",
          href: "https://discord.gg/3sDbYc9SZP",
        },
      ],
      customCss: [
        "./src/tailwind.css",
        "./src/styles/custom.css",

        "@fontsource/jost/100.css",
        "@fontsource/jost/200.css",
        "@fontsource/jost/300.css",
        "@fontsource/jost/400.css",
        "@fontsource/jost/600.css",
        "@fontsource/jost/700.css",
        "@fontsource/jost/800.css",
        "@fontsource/jost/900.css",

        "@fontsource/readex-pro/200.css",
        "@fontsource/readex-pro/300.css",
        "@fontsource/readex-pro/400.css",
        "@fontsource/readex-pro/600.css",
        "@fontsource/readex-pro/700.css",
      ],
      components: { Hero: "./src/components/Hero.astro" }
      
    }),
    react({
      include: "./src/components/*.[jsx|tsx]",
    }),
  ],
  vite: {
    plugins: [tailwind()],
    resolve: {
      alias: {
        "@components": "/src/components",
      },
    },
  },
});
