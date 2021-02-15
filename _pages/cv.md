---
permalink: /cv/
title: "Why should you hire me?"
toc: true
skills:
  - Knowledge management
  - APIs and API design
  - Engineering systems and cultures
  - Team/people management
  - Systems design and architecture
  - SDLC
  - Software quality
  - Debugging
  - Performance optimization
tools:
  - Confluence
  - MediaWiki
  - Jira
  - Git
  - GitHub
experience:
  - title: Director, Systems Architecture
    employer: First Republic Bank
    start: February 2019
    end: Present
    tech:
      - Kafka
      - Apigee
      - .NET Core
      - JavaScript/TypeScript
      - OpenShift/Kubernetes
      - AWS
    bullets:
      - |
        Led architecture efforts on enterprise-wide initiatives for API
        gateway and real-time data implementations with Apigee and Kafka
      - | 
        Led a small architecture team working as horizontal solution
        architecture and API experts for a banking core replacement effort
        (10+ major workstreams, 50+ total projects)
      - | 
        Led enterprise efforts on software quality and SDLC compliance,
        including devising new quality metrics based on engineering community
        health
      - |
        Built out developer guidance on application architecture/non-functional
        requirements, software patterns, system design, and API design.
      - |
        Worked with diverse teams across lines of business to help drive
        technology roadmaps, as well as identify opportunities for strategic
        alignment and reuse.
      - |
        Served as a subject matter expert on all aspects of software
        development: technology stack selection, framework/library evaluation,
        code review, etc.
      - |
        Worked with teams to help transition and structure new knowledge
        management facilities, including moving information from Sharepoint to
        Confluence, and establihing workflow guidelines for Jira
  - title: Principal Engineering Manager
    employer: CareStack
    start: October 2018
    end: December 2018
    tech:
      - Azure
      - SQL Server
      - .NET
      - TypeScript/JavaScript
    bullets:
      - |
        Led a tribe of 17 engineers working on the front office portions of
        CareStack's dental practice management system
      - |
        Championed and implemented engineering systems and culture changes to
        improve throughput, output quality, and quality-of-life for developers
      - |
        Mentored engineers on the team, ranging from senior to very junior and
        organized team into multiple squads with product focus areas to further
        improve the way we worked
      - |
        Led a release that fixed dozens of bugs and resulted in dramatic
        stability and reliability improvements
      - |
        Short tenure resulted from a disagreement between the CEO and the entire
        senior engineering staff about best practices
  - title: Sr. Software Engineering Manager
    employer: Microsoft
    start: July 2016
    end: September 2018
    tech:
        - Xamarin
        - .NET
        - Cocoa/AppKit
        - Android
        - TypeScript
        - WASM
        - Azure DevOps
    bullets:
      - |
        Planned and executed on transition of Xamarin services and teams into
        Microsoft as part of Microsoft's acquisition of Xamarin
      - |
        Moved to the Xamarin Workbooks team as part of winding down Xamarin
        infrastrucure and operations
      - |
        Drove Workbooks integration with Xamarin.Forms, including integration
        into the layout inspector and evaluation engine, as well as correct
        mapping of the native and Xamarin.Forms visual trees
      - |
        Led accessibility improvements to the desktop client and web editing
        surface, including new design and color elements
      - |
        Implemented an improved plugin/pipeline system that powered 3rd party
        integrations with Workbooks
      - |
        Built a WebAssembly evaluation environment for Xamarin Workbooks that
        leveraged a horizontally scalable server-side for compilation, while
        remoting execution into a WebAssembly-hosted Mono VM
      - |
        Worked closely with relese engineering/management teams to maintain and
        improve engineering/build systems that powered day-to-day work and
        release efforts
  - title: Engineering Manager/Operations Lead
    employer: Xamarin
    start: February 2012
    end: July 2016
    tech:
        - .NET
        - AWS
        - Azure
        - Salesforce
        - GTK+
        - JavaScript
        - Redis
        - SQL Server
        - MySQL
    bullets:
      - |
        Led the team responsible for most of Xamarin's customer-facing
        infrastructure (Xamarin Store, Component Store, Single Sign-On,
        Licensing)
      - |
        Scaled and optimized infrastructure, serving a few billion API calls per
        month on minimal hardware
      - |
        Devised a novel approach to licensing infrastructure from both the
        server and client side, resulting in more robust client licensing, and
        greatly improved performance, reliability, and debuggability of the
        infrastructure itself
      - |
        Developed and maintained processes to improve efficiency of sales and
        support process.
      - |
        Worked closely with finance and executive teams on business
        intelligence, fundraising, and general operations understanding. Devised
        new spins and presentations of data, and correlated it to
        product decisions and output.
      - |
        Built the Xamarin component store and worked on its integration into the
        Xamarin Studio IDE, as well as contributing general fixes to the IDE
  - title: Software Developer/Consultant
    employer: Cane Systems
    start: August 2010
    end: February 2012
    tech:
      - Java
      - PostgreSQL
      - Oracle DB
      - Cisco/Juniper
    bullets:
      - |
        Worked as an on and off-site consultant in the telecommunications
        industry, focusing on operations support systems (OSS) and other
        network/physical plant management projects
      - |
        Developed a new system for tracking fixed assets and points of presence,
        including rich mapping and navigation capabilities built in
      - |
        Built solutions to collect and manage hardware inventory and hardware
        status from native systems that did not integrate into centralized OSS
  - title: Software Developer
    employer: Air Power Analytics
    start: February 2009
    end: February 2012
    tech:
      - Java
      - C#
      - ActionScript/Flash
      - PHP
      - Oracle
      - Serial Protocols
    bullets:
      - |
        Rewrote a sensor metrics collection platform from the ground up,
        delivering multiple order of magnitude improvements in polling and
        memory efficiency
      - |
        Built infrastructure to securely deliver collected data back to central
        server from each on-site location, and pre-process it for ETL
      - |
        Built two front-ends, a "live" frontend that could run on any computer
        on the same network as the collection platform and view live data, and a
        reporting frontend that worked off ETLed data
      - |
        Evaluated and identified hardware with suitable characteristics for
        metrics collection platform that was suitable for use in industrial
        plants
---

## About Me

Broadly speaking, I'm T-shaped &mdash; I'm comfortable leading teams and
managing people, diving into code (writing, reviewing, debugging, optimization,
etc.), building infrastructure, working on engineering systems and culture,
building software development lifecycle policy, structuring out knowledge
management (ask me about why it's key to healthy organizations!), and designing
systems architectures. I'm a Git wizard, a comfortable and proficient technical
writer, and I love to teach and mentor. I'm comfortable learning on the fly
&mdash; I firmly believe that for most engineers, the things you already know
aren't important, but your curiosity and learning/knowing how to learn[^0] are what
will determine your success.

If you're a startup, I also bring experience in the business of startups &mdash;
the team I led at Xamarin worked closely with finance, sales, and executive
teams to devise and build new approaches to collating and understanding business
data, and extract insights that correlated to how we built and shipped our
software.

## Experience

{% for job in page.experience %}
### _{{ job.title }}_ at **{{ job.employer }}**
<p style="margin-top: -0.75em;" class="footnotes">
  <small>From <strong>{{ job.start }}</strong> to <strong>{{ job.end }}</strong></small>
</p>
<ul>
{% for bullet in job.bullets %}
<li>{{bullet}}</li>
{% endfor %}
</ul>
Technologies: {{ job.tech | join: ", " }}
{% endfor %}

## Contacting Me

The best way to reach me re: hiring is [via email][email]. You can also message me on
[LinkedIn][lin], or find my Twitter, etc.   

[^0]: "Many have marked the speed with which Muad'Dib learned the necessities of
    Arrakis. The Bene Gesserit, of course, know the basis of this speed. For the
    others, we can say that Muad'Dib learned rapidly because his first training was
    in how to learn. And the first lesson of all was the basic trust that he could
    learn. It is shocking to find how many people do not believe they can learn, and
    how many more believe learning to be difficult." - Frank Herbert

[email]: mailto:resume@coderinserepeat.com?subject=Position%20at%20YourCompanyHere
[lin]: https://linkedin.com/in/brajkovic