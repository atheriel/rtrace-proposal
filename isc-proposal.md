ISC Proposal: An External R Sampling Profiler
================
Aaron Jacobs
2019-10-12

# Signatories

<!-- 
This section provides the ISC with a view of the support received from the community for a proposal. Acceptance isn't predicated on popularity but community acceptance is important.  Willingness to accept outside input is also a good marker for project delivery. 

An optional section would be for R-Core signatories where changes to R are proposed.
-->

## Project team

<!-- 
Who are the people responsible for actually delivering the project if the proposal gets accepted and are already signed up and rearing to go?
-->

  - **Aaron Jacobs**, Data Scientist at Crescendo Technology

## Contributors

<!-- 
Who are the people who have actively helped with this proposal but won't necessarily be on the core project team later?
-->

## Consulted

<!-- 
Who has been given the opportunity to provide feedback on the proposal? This should include any R Consortium & ISC members who the proposal has been discussed with.
-->

# Motivation

<!-- 
Outlining the issue / weak point / problem to be solved by this proposal. This should be a compelling section that sets the reader up for the next section - the proposed solution!

It is important to cover:

 - [ ] What the problem is
 - [ ] Who it affects
 - [ ] Have there been previous attempts to resolve the problem
 - [ ] Why it should be tackled
-->

How do R programmers identify and track down performance issues in their
code? As usual, we can and should try to collect data to answer these
questions.

Many R users will be familiar with using the built-in sampling profiler
`Rprof()` to generate data on what their code is doing, and there are
several excellent tools to facilitate understanding these samples (or
serve as a front-end), including the
[**profvis**](https://rstudio.github.io/profvis/) package.

However, the reach of `Rprof()` and related tools is limited: the
profiler is “internal”, in the sense that it must be manually switched
on to work, either during interactive work (for example, to profile an
individual function), or perhaps by modifying the script to include
`Rprof()` calls before running it again.

At present, there is no way to collect useful information on R code that
cannot by manually instrumented with `Rprof()` or that is already
running. This makes it very difficult to answer questions like the
following:

  - How does an R application that you didn’t write – and therefore have
    limited understanding of how to instrument – spend its time?

  - An R program is misbehaving in production, taking far longer to run
    (or do its work) than we expected or experienced in other
    environments. What is it doing?

Instead, R programmers usually resort to trying to reproduce these
problems in local, interactive sessions.

Of course, it’s not quite the case that we have *no* visibility into
already-running code; for instance, we could measure CPU usage by the
process in question, or time how long it takes to finish. But these
methods don’t provide any real insight as to where the problem might be
– for that, we need the kind of information about the R stack that
`Rprof()` provides.

Many existing programming languages have one or more “external”
profilers available, for example:

  - The Linux system profiler `perf` will print sampled C/C++ stack
    traces.
  - The `jstack` program for Java (among others).
  - The Windows `VSPerfCmd` tool for C\#/.NET applications.
  - [Pyflame](https://github.com/uber/pyflame) for Python; and
  - [rbspy](https://rbspy.github.io/) for Ruby.

All of these programs can “attach” (in one way or another) to a running
process and inspect its memory at some frequency to understand what the
current language-specific stack looks like. The last two are especially
appealing, because they, like R, are interpreted languages, and show
that it should be possible to produce a similar profiler for R.

Moreover, external sampling profilers have proven extremely useful for
diagnosing and fixing performance issues (or other bugs) in production
environments. As R moves more and more into this space, I believe this
could provide a substantial benefit to the community.

To our knowledge, there are no existing external sampling profilers for
R, other than the demo discussed below.

# The proposal

<!--
This is where the proposal should be outlined. 
-->

## Overview

<!--
At a high-level address what your proposal is and how it will address the problem identified. Highlight any benefits to the R Community that follow from solving the problem. This should be your most compelling section.
-->

Project member Aaron Jacobs wrote a demo-quality external sampling
profiler for R earlier this year, which is available [on
GitHub](https://github.com/atheriel/rtrace).

This demo (1) proves that this is indeed possible for R; and (2) points
the way to the technologies that are needed to make it work.

We propose to turn this demo-quality project into a robust set of tools
that can be used by the wider community.

## Detail

<!--
Go into more detail about the specifics of the project and it delivers against the problem.

Depending on project type the detail section should include:

 - [ ] Minimum Viable Product
 - [ ] Architecture
 - [ ] Assumptions
-->

In order to make this tool more widely useful, we propose to break in
into two components: a command-line tool for users and a C library that
backs this program and other interfaces. This will involve:

  - Refactoring the existing code to be more robust, handle more diverse
    R environments, and report errors to the caller; and

  - Be sufficiently portable to work on any Linux distribution and any
    sufficiently recent version of R.

It is our view that a tool for R users is unlikely to be successful if
it does not have an R-level interface. To that end, the second major
goal of this project would be to create an R package backed by the same
library. Provided that this library is relatively portable and written
in C, we believe that such a package would be admissible to CRAN.

The delivery of a C library, command-line program, and R package that
work under Linux is the minimum viable product (MVP) of this proposal.

In addition to this MVP, we propose to “port” the tool so that it works
in two other common R environments:

  - Under Windows. Although there are likely fewer “production”
    deployments of R on Windows, it is a major platform for R users. The
    [rbspy](https://rbspy.github.io/) profiler for Ruby has shown that
    it is possible to support Windows in this way; we feel we could
    learn from them and make the same approach work for this project.

  - Under Docker. Although Docker is, of course, Linux, its use of
    process namespaces render the existing demo nonfunctional, and
    Dockerized R is very likely the medium-term future of production in
    R. The [Pyflame](https://github.com/uber/pyflame) profiler for
    Python has shown that it is possible to circumvent the namespace
    issues; we feel we could make the same approach work for this
    project.

## Alternatives

A new, external sampling profiler is not the only way to achieve live,
opt-in profiling of running R programs. It would also be possible to
modify R itself to switch on profiling in response to some kind of IPC,
such as a Unix signal.

However, there are major drawbacks to such an undertaking: it would
require modifying R itself, perhaps in ways that have an undesirable
impact on its complexity or performance, and would only allow code
running under new versions of R (perhaps quite some time from now) to be
profiled in this way. As a result, we believe a new tool is a better way
to accomplish the project’s goals.

# Project plan

## Start-up phase

<!--
Covering the planning phase, this section should provide a relatively detailed plan of how work will start on the project. This section is important because projects need to get up and running quickly.


 - [ ] Setting up collaboration platform inc. code for contributors etc.
 - [ ] Licence decisions
 - [ ] Reporting framework
-->

## Technical delivery

<!--
Covering the actual delivery of the project this section should provide at least a high-level the implementation. 

Including target dates is really important as you need to be committed and the ISC need to have a means of tracking delivery
-->

The timeline of the project is intended to be short:

  - Within one month. Delivery of the proposed MVP: refactoring of the
    demo into a portable C program and library for Linux, plus an R
    package interface.

  - Within the second month. Delivery of the proposed ports to Windows
    and Docker, plus a substantive blog post for the project and
    submission of the R package to CRAN.

Given the plan to work nearly full-time on this proposal, we believe
this should be possible.

## Other aspects

<!--
Covering non-technical activities like on-going publicity, paper preparation, discussion groups etc. that might be required to facilitate successful delivery of the project.

 - [ ] Announcement post
 - [ ] Delivery blog post
 - [ ] Twitter
 - [ ] UseR!
 - [ ] ISC meetings
-->

In order to publicise the project and ensure that R users can actively
benefit from it, we propose writing a blog post, ideally for the R
Consortium, explaining how to use the tools provided by the project.

Since the goals of the project are relatively narrow and use cases are
fairly narrow, we believe a single tutorial/evangelist-style post will
be the most appropriate reference point for the community.

# Requirements

<!-- 
An idea of what is required to make the project actually happen
-->

Since the deliverables of this proposal are all code, the requirements
of this project are the funding required to cover development costs.

No special tools, tech, or equipment beyond the existing resources of
project members will be required.

<!-- ## People -->

<!--
Who needs to be involved, what's the proposed structure, what will it take to get their involvement?
-->

<!-- ## Processes -->

<!-- 
What processes need to be put in place e.g. codes of conduct, regular ISC meetings, handover to the community at large?
-->

<!-- ## Tools & Tech -->

<!--
What is going to be needed to deliver this project? 

Will cloud computing be used - if yes are there are necessary components that will be deciding factors between providers?

Are there tools or tech that don't exist that will be produced to facilitate the project?
-->

## Funding

<!-- 
[TO DO] THE GUIDANCE IS PRETTY UNCLEAR, ESP IN LIGHT OF GABOR'S PROPOSAL VS AWARD SIZE

-->

We request a total of $8,500 to support the equivalent of 1.5 months
salary for project member Aaron Jacobs. He has arranged with his
employer to spend up to 80 percent of his time over the course of eight
weeks on unpaid leave to work on this project, should it receive
funding. His employer will continue to permit access to existing compute
resources to him during this time.

The award size in this case is similar to those of the successful
[sftraj](https://github.com/mablab/sftraj-proposal) and [Licensing
R](https://github.com/ThinkR-open/isc-proposal-licence) proposals,
namely that it essentially covers the cost of salary, and over a similar
period.

<!-- ## Summary -->

<!--
A summary of the requirements that contextualises the costs
-->

# Success

<!-- 
Projects should have a definition of done that is measurable, and a thorough understanding going in of what the risks are to delivery 
-->

## Definition of done

<!-- 
What does success look like? 
-->

## Measuring success

<!-- 
How will we know when success is achieved, what markers can we use along the way 
-->

## Future work

<!-- 
How could this be extended / developed in the future by yourself and/or the community in general?
-->

Our suggested future work would include

  - Packaging of the command-line tool for various Linux distributions,
    first and foremost the Debian project (and downstream distributions,
    including Ubuntu). This would improve the ease with which this tool
    would be available in these environments.

  - Support for macOS. Although it is unlikely that many users are
    running production workloads on macOS, it is a popular distribution
    for R developers.

  - Support for mixed-mode sampling of C/C++ and R stacks, as originally
    envisioned by the [Jointprof
    project](https://r-prof.github.io/jointprof/).

## Key risks

<!-- 
What sort of things could come up that can delay or break the project?

 - [ ] People
 - [ ] Processes
 - [ ] Tooling & Technology
 - [ ] Costs

-->
