---
layout: post
title:  "Euro-Office: Sovereignty Theatre or Real Engineering?"
date: 2026-05-03 14:02 +0100
categories: [Open Source]
tags: [euro-office, sovereignty, data-sovereignty, open-source, office, nextcloud, gdpr, odf, regulation, politics, eu, us]
---

I was genuinely excited when I first heard about Euro-Office. If you're not deep in the self-hosted ecosystem, a bit of context: for years, anyone running their own cloud storage — typically via Nextcloud or similar platforms — has had two choices for browser-based document editing. Collabora Online, which is essentially LibreOffice running on a server and streaming rendered pages to your browser, is mature and deeply committed to open standards, but carries the weight of a 35-year-old codebase and puts a heavy load on the server. OnlyOffice, developed by Ascensio System SIA (a company with roots in Russia, now registered in Latvia), takes a more modern approach — JavaScript-based, lighter in the browser, with excellent Microsoft format compatibility — but has always been opaque about its development, rarely accepts outside contributions, and has made controversial decisions like disabling mobile editing in its free Community Edition. Neither option has been fully satisfying.

Euro-Office looks like it could break that stalemate: a fork of OnlyOffice's modern codebase, but under European governance, with genuinely open development. I run my own Nextcloud instance and I'm looking forward to integrating it once it reaches a stable release.

But excitement is cheap. The interesting question is whether the engineering behind Euro-Office is actually solid, or whether this is just sovereignty theatre — a press release with a GitHub link. To find out, I cloned four of Euro-Office's repositories[^repos], read the documentation and README files, and went through the commit logs line by line. What started as a quick look grew into one of my longest articles yet — there turned out to be a lot to say. What follows is based on that primary-source review, supplemented by the project's public statements and third-party reporting.

## Why This Matters

I've wanted Europe — and Germany in particular — to become more independent in the IT sector for a long time. Not out of protectionism, but because depending on a handful of US vendors for the most basic tools of daily work — writing a document, editing a spreadsheet, collaborating on a presentation — is a structural vulnerability that can be weaponised at any moment. This isn't hypothetical: when the Trump administration sanctioned the International Criminal Court, Microsoft shut down the ICC chief prosecutor's email account[^tuta-countries]. A court based in The Hague, central to Europe's legal order, lost access to its own communications because a vendor in Redmond flipped a switch. The ICC has since announced it will move to openDesk[^tuta-countries]. That incident alone should have been a wake-up call for every European institution still running on US-hosted productivity software.

The legal picture is equally uncomfortable. Under the US CLOUD Act and FISA Section 702, US-controlled cloud providers can be compelled to hand over European data — even if it's stored on European soil — without notifying the data subject or any European authority[^fisa]. Under oath before the French Senate in June 2025, Microsoft's legal chief for France admitted that he could not guarantee French data would never be transferred to the US government[^tuta-sovereignty]. The same conclusion has been reached at the EU level: the European Data Protection Supervisor found that the European Commission itself violated its own data protection regulations by using Microsoft 365[^edps-m365].

I have to ask: how is any of this still GDPR-compliant? Microsoft's own lawyer cannot guarantee that European data stays in Europe. US law explicitly empowers US agencies to access it without European knowledge or consent. The EDPS has found the Commission itself in violation. And yet Microsoft 365 remains the default across most of European government and industry. Did no one pick this up? Or are we simply too dependent — too scared — to act on what we already know?

It seems, though, that the tide is finally turning. On 18 March 2026, Germany's IT-Planungsrat — the federal-state coordination body for government IT — adopted the Deutschland-Stack decision (B-2026/03-IT)[^itpr], which defines binding standards for all federal, state, and municipal digital infrastructure. The accompanying standards annex explicitly lists ODF (Open Document Format) and PDF/UA as mandatory document formats[^itpr-standards]. This isn't a suggestion; it's a binding resolution across all levels of German government.

Within Germany, the movement started at the state level. Schleswig-Holstein — the northernmost Bundesland — has migrated 80% of its 30,000 government workplaces to Linux and LibreOffice, and expects to save over €15 million in licence fees that would otherwise go to Microsoft's upcoming price increases[^tuta-countries]. With the Deutschland-Stack decision, that ambition has now reached the federal level as binding policy for all of Bund, Länder, and Kommunen.

But this is no longer just a German story. Denmark's Ministry of Digital Affairs has announced that all its employees will work with Linux and LibreOffice instead of Microsoft[^tuta-countries]. France, following the Senate testimony, announced in April 2026 that it would replace Microsoft on all government desktops with Linux[^tuta-sovereignty]. The Netherlands' municipality of Amsterdam has published a ten-year Digital Autonomy Strategy targeting full sovereignty by 2035[^tuta-countries]. Austria has launched its own sovereignty initiative under the Digital Austria Act 2.0[^tuta-countries]. And at the EU level, the European Commission awarded a €180 million tender for sovereign cloud services to European companies[^eurofocus]. As Thierry Carrez, general manager of Linux Foundation Europe, put it at KubeCon Europe 2026, the sovereignty conversation is now "happening at all levels of the stack"[^register].

What was once a personal conviction is now a procurement requirement — and that means there's suddenly real demand for a credible European office suite that can actually deliver.

## What Euro-Office Is

Euro-Office was announced on 27 March 2026 at a press event in Berlin[^7]. It is a fork of OnlyOffice — specifically of OnlyOffice's AGPL-licensed document editing engine — placed under European governance and open development. The coalition chose to fork OnlyOffice rather than build on LibreOffice/Collabora, explicitly citing OnlyOffice's more modern architecture and superior browser performance compared to LibreOffice's aging codebase[^9].

The backing coalition is substantive: IONOS, Nextcloud, XWiki, OpenProject, Soverin, Abilian, BTactic, and EuroStack[^7]. Proton is also involved[^8]. Both IONOS and Nextcloud have committed to hiring double-digit numbers of developers each for Euro-Office[^9]. That represents serious, sustained funding — not a press-release-and-forget play.

Architecturally, Euro-Office is an integration component, not a standalone product. It handles document editing — word processing, spreadsheets, presentations, and PDF — but storage, navigation, permissions, and sharing must be provided by a host platform: Nextcloud Hub, Proton Drive, Seafile, XWiki, OpenProject, or others[^2]. The fact that it works independently of Nextcloud[^12] is important: it means the project isn't captive to a single integrator's roadmap.

As of the 22 April update, the project has a published roadmap, a governance model, and a contribution process[^6]. The governance follows a "who codes, decides" principle with consensus-based decision-making among project members[^6]. Regular contributors are added by consensus after sustained contribution (roughly 3–6 merged PRs over a few months). A Code of Conduct based on the Contributor Covenant is in place[^2]. This is lightweight, but appropriate for the current stage — formalising too early kills momentum in young open-source projects.

So: real companies, real money, real governance. A published roadmap with a stable 1.0 targeted for summer 2026[^11]. But roadmaps are cheap too. The question is whether the actual engineering matches the ambition — and whether the project can navigate the political noise that has surrounded it since launch.

## The Licence Dispute, Briefly

Unfortunately, the waters around Euro-Office have been muddied by a licensing dispute with OnlyOffice that has attracted more attention than the actual engineering.

OnlyOffice is licensed under the GNU Affero General Public License v3 (AGPLv3), which explicitly grants the right to fork, modify, and redistribute. OnlyOffice has, however, added an additional clause under Section 7 §3(b) requiring preservation of their branding and logos. This is where the dispute lies.

Euro-Office's position is that they are attributing correctly. The Ascensio credit appears in the theming config, in the codebase, and on the About screens for both desktop and mobile — the engineering details are covered in the theming section below[^5]. Nextcloud has published a detailed legal analysis arguing that the Section 7 additions are non-obligatory under the AGPL[^1]. The Euro-Office community has also published a detailed account of the changes they've made to ensure licence compliance, including restoring mobile editing that OnlyOffice had artificially disabled and cleaning up the DesktopEditors dual-licence to pure AGPLv3[^4].

OnlyOffice disputes this. They have publicly stated that Euro-Office constitutes "an evident and material violation of ONLYOFFICE licensing terms"[^oo-neowin] and suspended their eight-year partnership with Nextcloud over the fork[^oo-neowin]. They argue that the additional branding terms cannot be separated from the main licence.

I am not a lawyer and cannot judge the legal merits of either side. What I can say is that from my limited understanding, Euro-Office appears to be making a good-faith effort to properly attribute: the Ascensio credit is in the code, in the config, and on the About screens. The AGPL grants forking rights. Whether the Section 7 branding clause survives a fork is ultimately a legal question that may or may not be tested in court. But the fork itself is not a violation of open-source norms — it *is* the norm. That's how the AGPL works.

Enough about lawyers. Let's look at the code.

## What the Commit Log Shows

The GitHub organisation hosts ~15 repositories covering the full stack[^2]: DocumentServer (orchestration, Docker builds, CI), core (C++ conversion engine), sdkjs (JavaScript editing SDK), web-apps (frontend UI), a Nextcloud integration app, DesktopEditors, desktop-apps, and supporting repos for dictionaries, fonts, document formats, and templates. A working Docker image is available[^3]:

```
docker pull ghcr.io/euro-office/documentserver:latest
```

This is a deployable document server, not a placeholder. The DocumentServer repo alone has over 300 commits on `main`. All key repos show commit activity through late April / early May 2026.

The commit log reveals several distinct work streams, each visible as clusters of commits.

### 1. Automated Licence Stripping (DocumentServer, 26 March)

The single largest cluster of early commits — at least ten — built a GitHub Actions workflow that automatically strips the AGPL Section 7(b) trademark clause from all copyright headers after upstream merges (`a0f7c65`, `ca65168`, `5674745`, `1a14462`, among others). The iteration is telling: they refined edge cases around blank-line handling, commit message formatting, a check-mode-first safety step, and making the merge optional. A revert (`6c0d308`) and subsequent re-approach shows real engineering discipline — they broke something, backed out, and fixed it properly.

This is the foundational infrastructure for staying mergeable with upstream while maintaining their own licence posture. Getting it right early was the correct priority.

### 2. Build System Overhaul (DocumentServer + core, 28–31 March)

The C++ dependency management was switched from Conan to vcpkg (`7873c20`). Docker builds were restructured around `docker buildx bake` for reproducible multi-stage builds (`f04a1a4`). A `.deb`/`.rpm` packaging pipeline was added (`8136765`, `9bbd9f7`), along with Vagrant VMs for Ubuntu 24.04, Debian 12, and Rocky Linux 9 to smoke-test produced packages[^builddir]. There are numerous fix commits wrestling with registry URLs, caching, and workflow files (`b6992c9`, `71168a4`, `dcc0114`, among others) — classic "getting CI green" work that anyone who has set up a non-trivial build pipeline will recognise.

OnlyOffice's build process was one of the core grievances that motivated the fork: their README describes it as "unreliable, outdated or just plain broken"[^2], with binary blobs and compiled/obfuscated code. The commit log shows Euro-Office is doing the work to fix this systematically.

### 3. ARM64 Support (core, 31 March – 2 April)

V8 and Boost were rebuilt for ARM64 (`1725c2b`). Emscripten was updated for ARM compatibility (`5057738`). Architecture-aware vcpkg triplets were introduced (`f320bdf`). The web-apps build skips `imagemin` on ARM64 since its native binaries are x86_64-only[^devdir]. There is no GHCR ARM64 image yet — ARM users must build locally — but the groundwork is laid.

### 4. WASM / Emscripten (core, 28 March – 16 April)

Multiple commits address WebAssembly builds: fixes to DrawingFile and general layout (`52518f8`), the V8 build process (`ad832ca`), and a notable fix deferring FreeType function bindings until `onRuntimeInitialized` (`146975f`). This is browser-side rendering work. If mature, it would reduce the heavy server-side load that has always been Collabora Online's architectural weakness — and it would be a significant differentiator.

### 5. Rebranding and Theming (web-apps, 19 March – 22 April)

Icons were shifted from PNG to SVG (`5cd4c4e`, `d863b5b`, `3c81545`), including dark-theme variants. A theming system was introduced with `config.json` as single source of truth for brand values[^5] — company name, publisher URLs, logo filenames, and an attribution line reading `"Euro-Office was based on ONLYOFFICE by Ascensio System SIA"`. Two build pipelines consume the theme: Grunt for desktop (using `{{PLACEHOLDER}}` token replacement) and webpack for mobile (using `DefinePlugin` constants and LESS globalVars). Hard-coded relative paths in build JSON files were replaced with a `$BUILD_ROOT` variable so the build works regardless of checkout location[^5]. About screens were updated with Euro-Office logos and Ascensio attribution on both desktop and mobile (`a8dd610`, `fbd8acc`, `4d5e670`, `cfdf091`).

This is proper fork infrastructure — making the codebase brandable and buildable by anyone, not just the original vendor.

### 6. Nextcloud Integration Modernisation (eurooffice-nextcloud, 28 February – 27 April)

This repo reveals that preparation started a full month before the public announcement. In late February, the frontend build was migrated from webpack to Vite (`c83a59b`), Vue and `@nextcloud/vue` were updated to v3+ (`323f6ac`), and raw-loader was removed (`ed84cc0`). In early March, a PHP refactoring pass improved type coverage (`272c9b1`), converted switch statements to match expressions (`414b549`), and removed redundant use statements (`ad68ba6`). PHP 8.4.x support was extended (`909d027`). Bug fixes addressed regex metacharacter escaping in MIME type handling (`e182df8`), file lookup error handling (`6c8114b`), and user ID prefix stripping (`09e6dc9`). Rebranding and repackaging for krankerl (Nextcloud app store tooling) followed on 26 March (`8131218`, `8de6d6d`, `cc4ac99`).

This was not a spontaneous fork. The Nextcloud integration was being quietly modernised and prepared for weeks before the Berlin launch.

### 7. Upstream Sync (web-apps, 10–17 March)

Two merge commits pull in OnlyOffice upstream changes from December 2025 (`868b36a`) and March 2026 (`39110cb`). An upstream CI file that attempted to use AWS was removed (`022e602`). This confirms active tracking of upstream — they're not just forking and walking away.

### 8. Mobile Dev Workflow (DocumentServer, 17–21 April)

Mobile dev mode was made independent (`0e075de`). Trusted domains were updated for Android development (`d624d5f`, `e134fcb`). A `make mobile` target was added with automatic LAN IP detection for off-desktop testing[^devdir]. Documentation was updated accordingly (`2b18260`).

### 9. Governance and Contribution Docs (DocumentServer, 20–22 April)

CONTRIBUTING.md was written and refined across multiple commits (`598141c`, `fdb545b`, `4d3145d`, `5e4e087`). A CODEOWNERS file was added for the server team (`9540d86`). An attributions file was introduced (`e6b9bf8`). Coding guidelines were published.

### 10. Testing (core, 1 April)

An ODT conversion test snapshot was updated for Japanese AIUEO numbering format (`03fcc6a`) — evidence that automated conversion and rendering tests are being maintained, not just inherited and ignored.

## Assessment

Five weeks in, for a fork of a complex codebase, this is about as good as you could reasonably hope for. The commit log tells the story of a team doing the right things in the right order: licence automation first, build reproducibility second, ARM and WASM groundwork third, branding and theming fourth, governance and contribution docs fifth. The Nextcloud integration work predating the public launch by a month shows planning, not improvisation. The stable 1.0 is targeted for summer 2026[^11] — and given they're building on a mature, already-functional codebase rather than starting from scratch, the timeline is plausible, though "summer" is doing some heavy lifting.

That said, several open questions will determine whether Euro-Office becomes a serious contender or just another well-intentioned European initiative that fizzles out.

**ODF as native format.** The Document Foundation published a pointed response noting that the original Euro-Office press release didn't mention ODF even once[^10], and asking whether ODF will be the native format. That's a legitimate architectural question: if Euro-Office inherits OnlyOffice's OOXML-first posture, it's sovereign in governance but still format-dependent on Microsoft's specification. As discussed above, the Deutschland-Stack standards already mandate ODF for all German government IT[^itpr-standards] — any office suite that wants to serve the European public sector needs ODF not just as a supported export option, but as a first-class citizen. The latest Nextcloud update lists "full ODF support" as a roadmap priority[^6], which suggests they heard the criticism. But whether ODF becomes the *native* default or just a well-supported secondary format is an open question that will matter for procurement decisions across Europe.

**Upstream tracking vs. divergence.** The commit log shows two upstream merges from OnlyOffice so far — December 2025 and March 2026 changes pulled into web-apps. That's a healthy sign early on. But as Euro-Office accumulates its own changes — the theming system, the build overhaul, the licence stripping automation — merging upstream will get progressively harder. At some point, they'll need to decide whether to track upstream closely or diverge intentionally. Both are viable strategies, but the choice will shape the project's long-term character.

**Governance scaling.** The current "who codes, decides" model works for a founding coalition of a dozen organisations. It won't work at fifty. As the contributor base grows — and it will need to grow if the project is to deliver on its ambitions — the governance will need to formalise without becoming bureaucratic. The early signs are positive (CONTRIBUTING.md, CODEOWNERS, Code of Conduct), but this is a problem that only gets harder with success.

**WASM maturity.** The browser-side rendering work via WebAssembly is potentially the most significant technical differentiator Euro-Office could offer. If the WASM path matures, it would shift rendering from the server to the client — fundamentally changing the economics of deployment and addressing Collabora's biggest architectural weakness. The commit log shows active work here, but it's clearly still early.

The commit log doesn't resolve these questions. But it does show that real engineers are doing real work, with real money behind them, and that the work so far has been competent and well-prioritised. That's more than most forks can show at five weeks.

What makes me genuinely hopeful is not just Euro-Office itself, but what it represents. For years, European digital sovereignty has been something people talked about at conferences and wrote into strategy papers, but the actual tools lagged behind the rhetoric. Now, for the first time, there's a concrete, funded, technically credible effort to build an office suite that Europe can truly call its own — not just in governance, but in code. If Euro-Office delivers on its promise, it won't just be a replacement for one piece of software. It will be a proof of concept that Europe can build and maintain critical digital infrastructure independently, from the document layer all the way up. That's the real prize.

I'll be revisiting this when 1.0 lands — and I'll be hoping to deploy it on my own Nextcloud shortly after.

---

*Methodology: Repositories were cloned on 3 May 2026 using `git clone --depth` (30–100 commits per repo). I reviewed the commit messages, dates, and authors — not the actual source code diffs. For each commit, I categorised it by topic (licence stripping, build system, ARM64, WASM, theming, etc.), then summarised the topic clusters into the work streams described above. README files, build documentation (`build/`), and developer documentation (`develop/`) were read directly from the cloned repositories. External sources were consulted for coalition, governance, and roadmap context.*

---

[^repos]: Repositories cloned: `Euro-Office/DocumentServer`, `Euro-Office/web-apps`, `Euro-Office/core`, `Euro-Office/eurooffice-nextcloud`. All available at https://github.com/Euro-Office
[^1]: Nextcloud, "Euro-Office: License compliance and what open source means," 22 April 2026. https://nextcloud.com/blog/euro-office-license-compliance-and-what-open-source-means/
[^2]: Euro-Office GitHub organisation, profile README. https://github.com/Euro-Office
[^3]: Euro-Office DocumentServer repository. https://github.com/Euro-Office/DocumentServer
[^4]: Issue #3645 on ONLYOFFICE/DocumentServer, "Euro-Office: A fully FOSS fork of ONLYOFFICE — join us on Codeberg," 2 April 2026. https://github.com/ONLYOFFICE/DocumentServer/issues/3645
[^5]: Euro-Office web-apps repository (theming config and build variable documentation). https://github.com/Euro-Office/web-apps
[^builddir]: Euro-Office DocumentServer build documentation. https://github.com/Euro-Office/DocumentServer/tree/main/build
[^devdir]: Euro-Office DocumentServer develop documentation. https://github.com/Euro-Office/DocumentServer/tree/main/develop
[^6]: Nextcloud, "Euro-Office: Building momentum," 22 April 2026. https://nextcloud.com/blog/euro-office-building-momentum/
[^7]: Nextcloud, "Industry initiative launches Euro-Office as true sovereign office suite," 27 March 2026. https://nextcloud.com/blog/press_releases/industry-initiative-launches-euro-office-as-true-sovereign-office-suite/
[^8]: TechSpot, "A new OnlyOffice fork is Europe's answer to Microsoft Office," April 2026. https://www.techspot.com/news/111952-new-onlyoffice-fork-europe-answer-microsoft-office.html
[^9]: heise online, "Microsoft alternative: Nextcloud and Ionos develop open-source 'Euro-Office'," 27 March 2026. https://www.heise.de/en/news/Microsoft-alternative-Nextcloud-and-Ionos-develop-open-source-Euro-Office-11228123.html
[^10]: The Document Foundation Community Blog, "Euro-Office: sovereign in name only, or in reality too?" 1 April 2026. https://blog.documentfoundation.org/blog/2026/04/01/euro-office/
[^11]: Sovereign Cloud Architecture Initiative, "Euro-Office," 1 April 2026. https://yeandel.co.uk/22-q2-2026-updates/euro-office.html
[^12]: DB Tech Reviews, "Euro-Office Doesn't Need Nextcloud — And That Changes Everything," 8 April 2026. https://dbtechreviews.com/2026/04/08/euro-office-doesnt-need-nextcloud-and-that-changes-everything/
[^oo-neowin]: Neowin, "ONLYOFFICE suspends Nextcloud partnership over unapproved 'Euro-Office' fork," 1 April 2026. https://www.neowin.net/news/onlyoffice-suspends-nextcloud-partnership-over-unapproved-euro-office-fork/
[^itpr]: IT-Planungsrat, Beschluss B-2026/03-IT — Deutschland-Stack, 49. Sitzung, 18 March 2026. https://www.it-planungsrat.de/beschluss/b-2026-03-it
[^itpr-standards]: IT-Planungsrat, Anlage Standards zum Beschluss B-2026/03-IT, 18 March 2026. https://www.it-planungsrat.de/fileadmin/beschluesse/2026/Beschluss_2026_03_Deutschland-Stack_Standards.pdf
[^tuta-countries]: Tuta, "France ditches Microsoft for Linux to achieve digital sovereignty — and it's not the only one!" April 2026. https://tuta.com/blog/countries-ditching-microsoft-choosing-linux-digital-sovereignty
[^tuta-sovereignty]: Tuta, "What is digital sovereignty — and how Microsoft sparked the trend," March 2026. https://tuta.com/blog/digital-sovereignty-europe
[^register]: The Register, "Digital sovereignty isn't just a buzzword — it's the future," 13 April 2026. https://www.theregister.com/2026/04/13/digital_sovereignty/
[^fisa]: SoftwareSeni, "How the US CLOUD Act and FISA 702 Create Legal Exposure for EU Cloud Data," 27 February 2026. https://www.softwareseni.com/how-the-us-cloud-act-and-fisa-702-create-legal-exposure-for-eu-cloud-data/
[^eurofocus]: Europe Focus, "The EU turns to 'Made in Europe' tech solutions," April 2026. https://www.europefocus.eu/the-eu-turns-to-made-in-europe-tech-solutions/
[^edps-m365]: European Data Protection Supervisor, investigation into use of Microsoft 365 by the European Commission, March 2024. https://www.edps.europa.eu/system/files/2024-03/24-03-08-edps-investigation-ec-microsoft365_en.pdf
