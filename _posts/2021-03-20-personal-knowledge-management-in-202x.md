---
title: "Knowledge management in the modern era"
date: 2021-03-20
tags:
- Knowledge Management
- Organization
- Mental Models
category: Essays
excerpt: >-
  In which I ruminate on what knowledge and document management looks like in the modern era.
---

A few things have happened recently that have gotten me thinking about what the broader scope of knowledge management
(going beyond blogs and personal wikis, casting a wider net into all of the data generated by a person's life) looks
like in the 2020s:

1. [This thread][thread] with my friend Joel, in which I riff on what I think a modern version of Vannevar Bush's Memex
   would look like, and how it compares to some existing tools out there (Microsoft's ToDo/OneNote suite + the general
   internet). I was originally introduced to the Memex by [Charlie Stross's][cstross] Laundry Files series, and was
   instantly fascinated by its presentation as an electromechanical contrivance that when imbued with sufficient magic
   granted the user's "data" access/perusal speeds almost equivalent to "main memory." Since then, Vannevar Bush's "As
   We May Think," which introduced the Memex (as well as several other interesting ideas about how we capture and access
   our life's data), has been an influence on both my thinking and on this writing.
1. I think a lot about knowledge management at work. It's not a matter of secrecy that the bank I work at is currently
   in the midst of a CORE transformation[^0] project, nor is it a matter of secrecy that it constitutes about 80% of my
   work product these days. In particular, a project like this requires, as a matter of course, an enormous amount of
   documentation to be produced, and knowledge to be transferred: knowledge about the workings of the existing system,
   knowledge about how the new system is configured, and documentation about how the business processes translate from
   one system to the other. All of this has to be produced, organized, made accessible, and made searchable. More
   importantly, though, it needs to be **consistent** (all in one place) and **versioned**. The ability to visualize
   business logic change is paramount when dealing with such fundamental systems; every change at the core banking
   system level has 2nd, 3rd, and maybe even 4th order ripples. This is especially true when business process revision
   takes place at the same time as development work.
1. I scanned another batch of paper documents. These currently end up in a folder with hundreds of other scans, only
   loosely organized via filenames and some directory structure. The structure is mostly imposed by important events
   that generate significant paperwork that needs organization: real estate transactions (2 house purchases, 1 house
   sale, 1 refinance), each year's tax season, etc. The filenames alone are helpful, but my ability to look up a
   document is still nowhere near matching my ability to recall metadata about the document. Even when I find a scan
   that I'm looking for, I'm still missing the full context at my fingertips: I can't find related documents easily, I
   can't find related email easily, etc. Email is particularly important, especially with "paperwork generator" type
   events&mdash;much of the context behind a document still lives in that format: "Why did we have the lawyers draft
   this agreement to time out after 90 days versus 60 days?", for example.
   
The common thread between all of these is actually fundamentally simple: in each occurrence, in each data retrieval
context, the ability of my brain (and other brains…probably) to categorize ("I want all vet bills from 2019," "I want
all checks paid to my wife from June 2016 through July 2018") and to conjure up the "metadata" that I want to index on
far outstrips the ability of software systems (and physical systems&mdash;it'd be nearly impossible to do
cross-reference to the level I desire with physical documents). Bush's Memex, and its influence on early hypertext
systems (Engelbart's MOAD, for example), seemed to predict a future where our memory, with its prodigious capability to
categorize and cross-reference, would be supplemented with computer systems that were organized the same way. Yet here
we are in 2021, and all the systems I've tried recently still focus on the sterile familiarity of a filesystem-like
layout, mired in the land of directed acyclic graphs. Why?

# Was this really predicted in the 1940s

Yes. No, seriously. Go read ["As We May Think,"][awmt][^1], and notice that in 1945, Bush says this, at the beginning of the
[6th major section][awmt-text][^2]:

> THE HUMAN BRAIN FILES BY ASSOCIATION-THE MEMEX COULD DO THIS MECHANICALLY

Notice then that he has condensed my common thread from before into a single, pithy sentence: "The human brain files by
association." For the rest of the 6th section of "As We May Think," Bush takes the opportunity to point out that we've
created artificial sorting and hierarchy to place data in storage, when in reality, our mind does not work that
way&mdash;our ability to binary search sorted, hierarchical organizations of data to find a single document pales in
comparison to the speed at which a person is able to free-associate metadata[^3]:

> Yet the speed of action, the intricacy of trails, the detail of mental pictures, is awe-inspiring beyond all else in
> nature.

It is in this section that Bush lays out the "memex"&mdash;predating common use of the word "meme" by 30 years, he
chooses this as the name of his memory-enhancing devices. The memex sounds an awful lot like a "battlestation" setup of
the 202Xs: multiple screens, multiple control planes for various tasks, etc. However, it's biggest strength? In addition
to allowing its user to enter an endless stream of un-or-lightly organized data, it offers the ability to
cross-reference, to page and skim through data at amazing rates w/ mechanical assistance (and probably some mental
training, in skim-reading and categorization) and most of all, it supports the sort of serendipitous interaction that is
a key part of searching a pile of documents, putting together threads as you go.

# How do wikis fit into this?

It didn't take long after Ward Cunninghan's [1995 WikiWikiWeb][c2] for wikis to emerge as the leading approach to
knowledge management&mdash;early third party implementations of Cunningham's wiki concept emerged in the few years
following (TWiki in 1998, MoinMoin in 2000), and the concept gained ground quickly[^4]. Mediawiki's initial release in
2002 and the success of the Wikipedia project, and the release of Confluence in 2004 into the enterprise space (as well
as its subsequent success), really seemed to solidify the idea of the wiki as something that was here to stay.

Over time, wikis have built up a rich set of features that looks like it corresponds quite neatly with our stated
desires: good abilities to categorize and tag content, a rich markup for capturing notes and snippets of text, an
ability to contain more-or-less any kind of content (with limited degrees of usefulness), and a flexible storage
approach that isn't explicitly tied up in outdated filesystem notions. However, despite a seemingly solid foundation,
even the latest installments of wikis fall short when it comes to being an augmentation of the human intellect.

## Failing #1: Poor support for non-plaintext knowledge

Wikis are, by nature, built for plaintext knowledge&mdash;they're intended to present textual documents, and serve as a
knowledge repository for data that could be principally described as documentation. Their evolution has led to primary
use as encyclopedia-alikes, whether that's the public Wikipedia, enterprise/corporate wikis (I've seen Mediawiki,
Confluence, home-grown wikis, even GitHub's Gollum wiki in this space), or personal wikis (most frequently used for
stuff like "The plumber is John Doe, his number is 555-123-4567," which I like to refer to as "operational knowledge"
for one's life).

However, by focusing on text, wikis have more-or-less no document pipeline to speak of. Attachments are possible, but
there's no processing or indexing pipeline&dash;if you want to reference the content of, say, a bill PDF, you need to:

1. Extract the content into a page
2. Design a format for it (bills are generally easy and tabular, but not everything will be)
3. Do the transcription

This is pretty time consuming, and the UX still isn't great in cases where the content of the attachment is not
trivially transcribable to plaintext. This falls down just as hard when the data is textual, but not plaintext&mdash;for
example, if you want to store and index an email thread (see the first section of this essay, where I talk about
"paperwork-generating events"), you have to at a minimum copy all the contents out. At a maximum, you must separate the
messages, build a hierarchy for the thread, come up with the appropriate categorization, etc. The depth of the process,
however, is directly proportional to its final utility: a single page w/ a copy of all the contents is less broadly
useful than each email as a discrete, indexable, and referencable document.

A system more attuned to the needs of different document forms would recognize an email thread and categorize
appropriately, recognize a PDF and apply OCR/text extraction as needed, perhaps even recognize images and attempt to
make guesses at their contents, and use those to enrich the search index.

## Failing #2: Poor taxonomy/organizational UX

Another place where wikis fall down is in their taxonomy & organization UX. While most of them are able to be expressive
in their taxonomy, the actual presentation of the taxonomy always seems cast by the wayside. Rarely is the presentation
up front&mdash;generally speaking, the wiki expects you to enter via a landing page, which itself links to other pages.
Rarely is the organization of pages up-front&mdash;you're expected to maintain category pages, rather than being able to
use the category/tag itself as an entry point.

Consider the following case: I know I have a note/document somewhere that has information on the plumber that I use, and
I want to look up the plumber, and also see how much I've paid for various services via invoices. In most Wikis, I have
to either look up the "Professional Services" page, which then has the list of documents, find the Plumber, and look up
the bills from there. But the professional services page has to be linked from the landing, and maybe has to be
maintained manually. A system with a more up-front focus on taxonomy would give me an entry point to explore
categorization, or even give me a direct input into filtering the knowledge set using the predeclared taxonomy.

Organization-wise, wikis also tend to fall down because of their semi-global namespacing&mdash;Confluence in particular
has this problem, where if you want to express the same structure multiple times within a single "space," you are
completely barred from doing so! You have to either do contortions like `[Repeated Name]: Foo` and `[Repeated Name]:
Bar`, or create multiple spaces. Mediawiki has more or less the same issue&mdash;namespacing is possible, but ugly
(`Foo:Bar`), and still doesn't solve the repeating structure issue in a meaningful way.

# How do document management/enterprise information systems fit in?

As part of exploring the space, I've also looked at more pure document management/enterprise information systems. I'm
passingly familiar with Perkeep (f/k/a Camlistore), which I ran briefly at home, and Hyland's OnBase product, which my
employer uses. I've also looked at others, like DocumentCloud, PaperSave, etc. These systems have an area of strength,
and that's focusing on archival and document lineage&mdash;you get a data lineage, some classification, integration with
business workflow software in the "enterprise" cases. These features have value as an overall component of knowledge
management&mdash;nobody actually enjoys losing data, and knowing the history of where things came from is useful.

However, their utility as overall knowledge management systems is lacking. They tend to focus on hierarchical
organization, and have limited cross-referencing/tagging/categorization capabilities. As well, they tend to be focused
on discrete pieces of data&mdash;scanned documents, images, etc. While this is useful for probably 80% of what knowledge
management should be (especially in enterprise settings, where executed contracts, etc. are a major generator of
paperwork and need to be available for rapid lookup), it still doesn't help capture "flotsam" that is generated by
day-to-day activity. Even more usefully, they don't capture the dynamic, living notation that a wiki does, and are
minimally helpful in cross-referencing the two. Sharepoint is really a shining illustration of this&mdash;the document
upload functionality, the associated versioning, and search within those documents are all pretty good. However, it
really falls down because it's pure hierarchy, and its support for "wikis" is one of the most mediocre pieces of
software I've ever seen.

One place enterprise-targeted systems also deliver when it comes to search. SharePoint excels in this space (I've seen
it extract useful, searchable information from Office format files, PDFs, etc.). A piece of software in this category I
took a test drive of as part of researching what I wanted in this space was Kofax's [PaperPort][pp]. PaperPort was
appealing to me because of the promise of scanning to PDF, capturing on-the-go, and "transforming paper documents into
actionable digital information." It turns out, it is actually quite good at some of these&mdash;its scanning integration
is excellent, and it does a good job at OCRing and searching scanned documents (or extracting text from pre-OCRed
documents). I loaded a few documents from Tax Season a few years ago, and was able to quickly find them among the
preloaded demo library by searching for keywords that I knew would be tax specific. However, PaperPort fails in the same
way that most document management systems do: its categorization and organization approach is catastrophic. It remains
mired in hierarchical patterns&mdash;this is probably OK for enterprises, but doesn't work with my approach of
multi-categorization.

# What do I actually want in a knowledge management system?

Naturally, as part of writing this, I've thought a lot about what I actually need in a knowledge management system. Much
of this, I think, will be applicable to anyone looking to organize their knowledge. Some of it is probably idiosyncratic
to me, or at least not broadly applicable to everyone needing knowledge management. Even those places, I think, offer
readers a chance to maybe rethink the way they store, think about, and search their extended memory. Of course, I'm also
coming at this from a "maker"'s perspective&mdash;I build software for a living, so naturally, I've spent a fair amount
of time also thinking about how I would build this.

## Storage is obviously critical

I mentioned above that many document management systems have a principal focus on archival-quality storage&mdash;Perkeep
explicitly states in its mission that "Your data should be alive in 80 years, especially if you are." I don't know about
80 years, but I definitely don't like losing things. The good news is, I think storage is largely a solved problem.
There's probably room to argue on this, and it's going to be dependent in some part on **where** your data is held.
People running their own storage infrastructure (NAS, backups, etc.) probably will disagree a little bit that reliable
storage is a solved problem. 

While I have network-attached storage at home, and make extensive use of it, I would probably choose to build this
system on the public cloud. "Blob" stores are all capable of doing this job quite well, have reasonable costs, and
provide value in the form of some of their default features on top of just storage. For example, most of them have a
low-complexity versioning concept that would be sufficient to satisfy my desire to version knowledge where it makes
sense. AWS S3, Azure Blob Storage, GCP Cloud Storage are all satisfactory. Backblaze's B2 might be a dark horse
candidate, due to its cost and Backblaze's relative pedigree.

I'd probably use S3 anyway and eat the extra cost&mdash;I don't have enough data to store for the cost to
make a difference, and I'd probably build the rest of the system on AWS as well. If I were incentivized to make this
distributable, or meaningfully multi-user, I'd either use the filesystem (with some tricks to reduce disk use and
present data closer to the system's "mental" model[^5]), or automate separate cloud enclaves for each user of the
system. Some sort of password-derived KMS keywrapping, or something. Honestly, I haven't spent a lot of time needing to
build systems w/ user-generated content that absolutely cannot be commingled, so I'd ask people smarter than me. I'm
willing to hand-wave away some things&mdash;at the end of the day, I'm more focused on the taxonomic & UX portions than
on storage.

## Support for all types of media is another must

The system has to support all kinds of knowledge, and support them **naturally**. Free text (basically, wiki pages or
other scratch notes), PDFs, emails, etc. should all garner the same level of text-search support. I should never be in
the position where I'm having to build my own canonical representation of some piece of data, when I already have it on
hand! The email thread case from above I think is especially illustrative, as it's an area where existing system
probably fall down quite hard (except for maybe eDiscovery). I would make an exception for images, where I would expect
(and prefer!) to enter descriptive text around the subject of the image&mdash;as far as AI/ML systems have come in
identifying the contents of an image, they don't capture any of the surrounding context.

I'm not sure about how to best deal with audio/video data in this context, to the point where I'm almost tempted to
leave it out entirely, but that feels wrong. I think a first cut has to approach it in the same way we approach
pictures: free tagging and free "description" entry, with the description entry being indexed for search in the same way
all other text is. A possibility is to transcribe the audio track where available, but I'm not sure about the
computational price of that.

Versioning some of this data might be a challenge as well, and I think for the sake of reasonable constraints, I might
choose to **only** version user-generated, wiki-style content. Presenting "Track Changes" style version management of
Word/Excel/etc. documents might also be a possibility, if that data can be easily extracted, but since those are
self-contained within the document, I don't think they need storage assistance. In general, I find that Track Changes on
anything other than Word-style docs hard to understand&mdash;versioned spreadsheets should probably be database tables,
or at least Wiki pages where a diff is a little easier to render and understand.

I think there's really not much of a verdict to give here&mdash;all data is beautiful and deserving of our
attention. As to tools, I'd probably reach for Apache Tika for text extraction from various formats, and maybe ffmpeg or
similar tools for basic metadata extraction from audio/video. I'm not aware of any computationally inexpensive
approaches to audio transcription to complement human-entered description for audio/video tracks, so that would be a
good research area.

## Organization and search

Obviously, this system needs a really good approach to taxonomy, a robust metadata capability, and a search capability
that combines taxonomic searches, content searches, and metadata searches. I think the system needs to distinguish
between a few different types of searchable data:

1. Well-structured metadata, intrinsic to the piece of knowledge. Things like when was it entered into the system, when
   was it created, its original file name (distinct from the "name" within the system!), etc. Depending on the input,
   this intrinsic metadata extraction might bleed into what would otherwise be extrinsic. For example, email-type input
   would probably generate some taxonomic data automatically.
1. Structured, but extrinsic data. This is really what I would call "user-entered" metadata. This includes things
   like "when was this piece of knowledge created,"[^6] the taxonomic classification, user-entered related document
   linkage, etc.
1. Unstructured data, both intrinsic and extrinsic. This is the actual contents where they can be extracted (text, OCRed
   text, transcribed audio, etc.), or the human-entered descriptions where they can't (photos, videos, audio).

The taxonomic data itself has additional constraints. I know I've largely railed against hierarchies in prior sections,
but I think there is a utility to them at one or two levels of depth, as a complement to other taxonomic approaches. I'm
still firm on my belief that pure hierarchical organization does not work. Two things I would want to see in terms of
taxonomic approaches:

1. At least one level of high/top-level kindedness. These should be free-form, though. A naive approach would leverage
   data "kind" (images, documents, etc.) at the top level, but I think that again, flexible is better here. Especially
   in a business setting (and even in a personal one), you likely want top-level categories for things like check
   images, invoices, etc. so that you can separate quickly on broad-but-not-overbroad strokes. Nothing stops you from
   having multiple breadths of category, either&mdash;an intrinsic kindedness category based on the data kind, and an
   extrinsic category assigned by the user.
1. A free-tagging second layer of taxonomy, that allows for some natural hierarchicalization. I'm not yet sure whether
   this should require all layers to be represented, or simply infer them. The way I'm thinking about this is for,
   say, checks, you want to represent the `from` and the `to` as separate tags, so that you can express searches like
   "All checks from Pablo to me," or "All checks from me to my general contractor." The layers question boils down to
   whether `foo:bar` implies `foo` or not&mdash;my lean is that yes, it does.

Technologically, I'd take a "progressive enhancement" approach to storage. The intrinsic, well-structured
metadata I think could go into a relational database, along with notions of ownership, access control lists, etc.
Structured extrinsic metadata goes here as well, I think&mdash;most searches over it will be "whole word"-type searches,
that don't need the sort of "nearest neighbor" search approaches that unstructured data needs. For the unstructured
data, I think for small data volumes, something like PostgreSQL's GIN indexes + full-text search will be sufficient. At
larger data volumes, I'd probably reach for tools like Solr, Elastic, or custom work on top of Lucene. At sufficiently
large volumes, I'd look for an exit via Google acquisition, so they can apply their search work.

## Presentation & UX

Presentation and UX of the system are going to be just as important as the storage and taxonomic layers. There's a
number of problems with existing systems, but the two key ones for me are the process of loading data, and the "views"
into the data. This will probably be the longest section of "what I want to see," because it's by necessity the most
complex&mdash;without the benefit of a user experience, the "academic" storage and taxonomy qualities of the underlying
system are largely moot.

### Loading data into the system

Probably the most important part of the day to day interaction, actually bringing data into the system is an area that
has to be more fluid than it is today. My biggest issue with the systems I've tried so far, is that I have to enter each
piece of data individually, and no system I've used has ever shown me **what** I've just entered. This means that
anytime you need to batch-load data into the system, you have to inspect each piece by hand, upload it, enter the
metadata, and then go back to the next item. This batch upload with previewing is a key UX point, because it makes the
ingestion of data fast and natural.

Otherwise, there's a few key entry points for new data:

1. Drag-and-drop/file select + free entry of text from a web UI. This is pretty standard, and probably the primary
   mechanism for a lot of entry. Certainly "paperless home/office" scans, DSLR photos, bills, etc. would probably come
   in that way.
1. Wiki style, free-text entry. Good for notes, research work, documentation, etc. Pretty foundational for both personal
   and business use&mdash;personal wikis are a great way to store tradespeople's information, work histories ("plumber
   fixed blah on blah, refer to invoice blah", etc.). Wiki pages need at least basic cross-linking functionality (to
   each other, and to other data), but otherwise I think should probably be fairly vanilla Markdown (or other structured
   text) documents.
1. Mobile apps are a definite nice-to-have. Since all of the "built in" frontend (file upload & wiki editing) should be
   API driven, building in mobile support should be possible. The biggest benefit of this would be "share sheet"
   integration in the mobile OSes.
1. A neat trick for ingesting email would be to support forwarding to an assigned email address. Most, if not all, of
   the popular SaaS products for sending email also support this use case for receiving it. Ingesting mail this way
   preserves as much of the original metadata as is possible, and is convenient to boot.

### Viewing the loaded data

Because most systems are tied into their existing notions of hierarchies, they get this wrong when their first view is
purely hierarchical. In reality, there needs to be a number of different entry points, that represent different elements
of the taxonomy.

Going back to the description I gave above, I suggested two layers of taxonomy: categories, and tags.
In this system, each of these taxonomic layers has its own entry point&mdash;tags and categories, as well as their
associated hierarchies, each have their entry point. The knowledge/data-type hierarchy also has a distinct entry
point&mdash;even though it's not a principal point of organization for most of our purposes, it can be a useful entry
point, especially combined with the extrinsic taxonomic layers. This means that a "home" view needs to present all of
these different approaches to diving in, as well as a "search" entry point.

The search itself should aim to be natural, combining metadata searches with full text searches. The search language
should, whenever possible, try to make use of natural thinking/speaking patterns to formulate searches. An interesting
idea I had in this space is to utilize the natural spoken differences between `,` and `;` to determine disjunction vs.
conjunction. Owing to the shorter pause afforded by `,`, it becomes conjunctive: "Invoices, 2018, tradespeople" gives
you all invoices, paid in 2018, to tradespeople. Meanwhile, `;` becomes a disjunction: "Invoices; Checks"
gives you all documents matching (invoice OR check). There still remains ambiguity on whether `;` is inclusive or
exclusive&mdash;while a fascinating topic, it would be a major departure from this post, and best saved for other writing.

Another potentially useful view on the loaded data would be a "sync" view to the local system, especially when paired
with primary storage in the cloud. I mentioned this a while ago, and gave it a brief footnote, but I think it deserves a
little bit of extra coverage. The idea is to synchronize to a filesystem, and give each element of the taxonomic
hierarchy its own folder, and use links to reflect the fact that a document lives in multiple places, without
duplicating storage use. This type of synchronization would be especially useful with "media"-type documents, "paperwork
generating events," or things like pay stubs, where there are times that you want to just get a copy of everything
associated with a particular taxonomic element.

### Statistics and analysis

I'm actually not sure it makes much sense to do any sort of statistics or analysis on the stored data. None of the
obvious candidates are particularly interesting&mdash;who cares about file size, word count, etc.? Because our data is
massively heterogeneous, it's hard to do much primary key analysis/subject analysis in coherent ways. Maybe with a
consistent format for certain bills, you could do some analysis, but I don't belive it's worth it to do so in this
medium. Another concept I'm going to introduce, "workspaces," I think would provide a foundation for collecting the data
in order to analyze it in a more suitable suite of programs.

### "Workspaces"

The concept of a workspace here is one that's really useful for research-type activities. Workspaces are intended to
facilitate research threads, like someone might use for research/planning on a novel, or for geneological research. They
can be populated manually, via search, or via a search, like "smart search" folders in many email clients. The goal is
to tie together cross-referencing ability, display, and note-taking in a way that existing tools like OneNote and
Scrivener don't.

They're functionally not that different from a single taxonomic point view, but I see them as a potential extension on
top of that view that provides some ability to multi-view, take notes and have them be automatically stored w/ relevant
"related document" links, etc. A workspace is what I would have used while researching this post (for example, I re-read
"As We May Think" and read most of Engelbart's "Augmenting Human Intellect"), and I would have taken notes on each of
the papers, maybe even kept the blog post draft in the same workspace (remember, "wiki" style pages are just Markdown!).

# Mental models and techniques for this system

This is an area that I struggled to write, because there is an element of idiosyncrasy to this. Part of what makes this
system suited to me is that it is inherently compatible with my mental models and approaches to memory. The biggest
thing is that none of this is designed to require **memorization**. Quite to the contrary, it is designed to aid you in
not having to memorize prodigious amounts of information&mdash;you shouldn't feel the need to resort to any memorization
techniques or practices in order to use this system. What you will find helpful is the ability to free-associate, and to
explore drawing "conclusions" quickly. In general, my brain seems to be tuned for rapidly making connections between
various pieces of information, and that would be principally helpful in composing searches in this system, as well as
exploring related documents.

However, even that is probably limited in its utility, as the system is somewhat designed to help you build up that
ability to rapidly associate between information that you already know. After all, the taxonomic systems, intrinsic
metadata, and content extraction are designed to work with the little bits and pieces that you do remember, and help you
find the entire document (and all the related documents). Fragmentary pieces such as "a tax document from 2019" should
be enough to reduce the search space to something that you can brute-force. "a tax document from my employer" should be
sufficient to narrow down to the exact document or handful of documents that you need.

In fact, the most useful technique and mental model for this system? Get yourself in the habit of committing every
potentially useful piece of information/context to the taxonomy. The more richly you describe data when loading it into
the system, the less of it you have to remember.

# Conclusion

Whew. We're a touch over six thousand words in, and I've finally reached the end. My broad conclusion here is that most
existing systems for knowledge management fall short, in fairly predictable, consistent ways. Each of these ways is
intrinsic to the "type" of system! You could almost say it's each category's nature to fail in one of these ways:

1. They're too oriented toward "business process" integration, and don't support the capture of evolving knowledge,
   except when it can be locked into their hierarchical, discretized model. These are your enterprise-y document
   management type systems (PaperPort, OnBase, DocumentCloud, etc.). They sometimes deliver on the full-text search
   aspect, because businesses tend to have needs for that, and they're usually strong on storage (OnBase I know has a
   lot of flexibility here, that is genuinely useful to businesses), but taxonomic organization is not a concern for
   them.
1. They're too oriented toward pure storage, data longevity, and archiving. This is Perkeep and similar "long-term"
   archival systems. It's not that archiving and longevity are unimportant (like I said: nobody likes to lose data), but
   to me, it sort of misses the forest for the trees. I rarely want to store data merely for the sake of storing it,
   instead I want to derive insights, augment my memory, or have an "auditable"[^7] record of some event. Maybe there
   are systems out there that combine the two, but I haven't seen one yet.
1. They're too oriented toward plain text, and lack support for bringing non-plain text documents into their sphere.
   Wikis fall into this category, and they're great if you're able to fit everything you want to record in a wiki.
   They're frequently imperfect in their UX, but for the key cases of capturing evolving data and capturing operational
   knowledge (about your business, about your life, etc.), they tend to be the best tool for the job.

Everyone who uses existing knowledge management systems suffers for this:

1. Enterprises end up with a slapdash house of cards, suffused with inconsistent process, and half-used features. I know
   I've seen enough Confluence pages with attached Excel spreadsheets, or PDFs, or Word documents, to last me a
   lifetime. Meanwhile, some older documents live on SharePoint, which does a passable job with search on PowerPoints,
   PDFs, etc., but butchers wikis so badly that I'm surprised there hasn't been a class action lawsuit. They'll never be
   migrated to Confluence, because to do so would actually be a functional regression. Users of these enterprise systems
   suffer beacuse finding a canonical reference involves searching at least two, if not more, disparate systems.
1. "Regular" users suffer because they never have a system that integrates their operational knowledge with their
   operational knowledge&mdash;finding, say, "all the tradesperson invoices from 2020" ranges from "a few lookups" in
   the best case where you've already built a hierarchy around these concepts (Invoices &rarr; Tradespeople), to
   "manually trawl through everything trying to remember names" if you haven't. And even if you've already built the
   hierarchy, you're likely to have issues at some point: even highly organized people are likely to slip up at some
   point without the benefit of a consistent, computer-aided process. Take commercial plane flight for example: their
   process is highly aided by checklists and computers, and as a result, flying is the safest way to travel (per mile
   traveled), and it isn't close[^8].

Given the advancements in the technology (technological solutions exist for all the functionality I've outlined) and the
theory (I don't believe anything I've said here is a completely novel approach/idea), there's no reason that a modern
system should make so much distinction between operational (evolving) knowledge (in the form of wikis) and snapshotted
or frozen knowledge (in the form of fixed non-plain text documents). Better and easier knowledge organization would
allow people to operate more efficiently in their business lives and their personal lives. **We can, and should, do
better.**

<!-- Abbreviations, links, and footnotes after here. --> 

*[CORE]: Centralized Online Real-time Exchange
*[HELOCs]: Home Equity Lines of Credit
*[MOAD]: Mother Of All Demos

[thread]: https://twitter.com/joelmartinez/status/1359629846373048320
[cstross]: https://www.antipope.org/charlie/
[awmt]: http://mnielsen.github.io/notes/kay/assets/bush_1945.pdf
[awmt-text]: https://www.ps.uni-saarland.de/~duchier/pub/vbush/vbush6.shtml
[c2]: http://wiki.c2.com
[pp]: https://www.kofax.com/Products/paperport

[^0]: A CORE (hereafter, just "a core") is basically a ledger and processing center for bank accounts. In our particular
      case, we're replacing our "Deposits" core, which houses all our deposit accounts (checking, savings, etc.), and in
      an odd edge case, also houses residential mortgages and certain types of revolving/installment loans (like
      HELOCs). This is, in no uncertain terms, a big fucking deal that requires a lot of business and technology work
      and coordination to execute. The current system has been in service since the 80s, and is predictably deeply
      integrated.

[^1]: PDF form of scanned original article, with the section titles in place.
[^2]: Text link, missing section title, but much more readable.
[^3]: The word hadn't been coined in 1945 yet, and wouldn't be until 1968 by Phil Bagley.
[^4]: The author remembers wikis starting to be used for game guides in 2000/2001, and using Wikipedia for "research" in
      high school, probably around 2004.

[^5]: One of these clever tricks involves the gross abuse of hardlinks. I've in fact implemented this once before, and
      it works the following way: each file is stored in a single central directory, that's normally-hidden from the user.
      Directories are created that represent each tag/category as needed&mdash;even hierarchy can be represented this way (see
      the section on hierarchy in tagging). Then, each file is hard-linked into all of the hierarchy locations it belongs in
      (because things can be in multiple hierarchies/tags/categories!). From the user's perspective, everything is in the
      right places, but we reduce the amount of painful disk space use.

[^6]: This can, and might frequently be, different from the creation date of the file&mdash;think documents that are
      scanned months/years after their creation as paper/physical documents.

[^7]: In the sense of able to be trawled through, not any auditing like certificate transparency, blockchains, etc.
[^8]: 0.2 deaths per 10 billion passenger-miles for air flight. 150 deaths per 10 billion passenger-miles for driving.