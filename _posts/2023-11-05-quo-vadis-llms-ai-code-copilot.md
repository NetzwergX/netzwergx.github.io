---
layout: post
title: Quo vadis? LLMs for AI-assisted code copilots
date: 2023-11-05 15:09 +0100
categories: [AI]
tags: [AI, LLM, copilot, research]
---

Over the course of the decades, programming has seen major shifts in how the craft is performed. Where people wrote on punch cards which were then sewn into core memory by hand, there was not much in terms of automated assistance. By now, modern IDEs have long provided code completion and can give smart suggestions as to what a software developer might want to do. CI/CD pipelines and automated tests nowadays quickly verify the correctness of the given code (at least to a certain degree).

We currently see another big shift in how software is written unfolding before our eyes. AI-assisted code co-piloting is the newest variation of automation and code-completion that is aimed at making software development easier. Compared to traditional approaches, which used static analysis and the languages scoping rules together with hand-crafted templates, these tools leverage the power of Large Language Models (LLMs) which have been fine-tuned to provide code completion. A major contender in this space is [GitHub Copilot](https://github.com/features/copilot).

In this article, I wish to review a couple of research papers of the last three years to highlight the chances, but also the risks of those technologies and ask: Quo vadis? Where will the field of software development head in the near future, and what do we need to take care of so that this becomes a success story and not a gigantic money pit?

There are three papers in the last few years that truly stand out, and together form a somewhat concerning view on the wide-spread use of AI to write computer-assisted code. The three papers are 

* [Existence of Stack Overflow Vulnerabilities in Well-known Open Source Projects](https://arxiv.org/abs/1910.14374) (2019) by Md. Masudur Rahman and B M Mainul Hossain [^4]
* [Do Users Write More Insecure Code with AI Assistants?](https://arxiv.org/abs/2211.03622) (2022) by Neil Perry, Megha Srivastava, Deepak Kumar and Dan Boneh [^3]
* [The Curse of Recursion: Training on Generated Data Makes Models Forget](https://arxiv.org/abs/2305.17493) (2023) by Ilia Shumailov, Zakhar Shumaylov, Yiren Zhao, Yarin Gal, Nicolas Papernot and Ross Anderson [^2]

Lets begin with the second paper [^3], which posits the question "Do Users Write More Insecure Code with AI Assistants?". Unfortunately, the paper can be summarized with a single word: Yes. But it also highlights some more truly concerning facts about AI and LLMs.

Current research on verification of LLMs has led to the notion of "trustworthy AI" and "explainable AI". The thought was that with explanations, LLMs can become more than just black-boxes that we somehow have to trust to give us the right answers. Being neural networks (NNs), LLMs are just probabilistic models that produce *plausible* text. They have no notion of *knowledge* or *correctness* and can give hilariously wrong results that *sound plausible*. Especially with ChatGPT, there is a great danger in being overly confident in the output, because ChatGPT is trained to be *conversational* in tone, but also *confident* in what it says. Common wisdom under professionals nowadays is to only use LLMs like ChatGPT when one is able to *verify* the correctness of the output. That this is needed and warranted is highlighted by the very study quoted above. But lets dig into that a bit more, and look at why even getting *good explanations* cannot increase the confidence in the AI or make AI systems trustworthy.

What the study shows is that humans tend to be more critical of explanations if they *perceive* themselves as being knowledgeable of a topic, even to the point of being *overly* critic and not trusting the explanation. However, the study also shows that the less knowledgeable humans are about a topic, the more likely they are to trust any given explanation -- even if that explanation is completely and utterly wrong. The study is fascinating in how they generated and presented these fake explanations and how those were received by non-experts (in this case, they used pictures of bids and their classification as well as three groups of people -- professional ornithologists, hobby bird watchers and people without any background in birds). In my opinion, this leads to the very interesting possibility of an *explanation attack*, where LLMs might be trained to maliciously give wrong explanations and guide users towards actions they would otherwise not have undertaken.

Thus, we see that not even *explainable* AI might be enough to ensure good quality of the code or make the AI trustworthy. But lets assume for a moment that the AI is *trustworthy* in the sense that is has not been manipulated, but is actually trained to make a best effort to provide high-quality code along with explanations of this code. How does it get the training data?

Lets face it, most code out there in the real world isn't of the highest quality, most is just average, and as much code below average as above average. Training a model on the real code that is out there will just give us average results. So lets identify high-quality code along with good explanations of the code and train it on that. Stack Overflow has become the *de-facto* source of information for professional software developers and hobbyists alike, with about 21 millions questions already asked and most of them answered. As of Sept. 2023, during the week it has about 6k - 7.5k questions asked *per day* and goes down to about 4k on the weekend, highlighting the fact that it is much used by professionals during their work week [^1]. Suffice to say, SO is an influential source for professional software developers.

However, it is not free of errors. In fact, if we look at the first paper [^4], we can see that there are several highly ranked questions that do have security issues. These are widely copied over into open-source libraries, and it stands to reason that this flawed code has also found entry into many closed-source / proprietary computer programs.

This highlights two important issues, especially together with the study quoted above: First, explanations are not enough even when they are provided, since they might come flawed sources. Even when the LLM were to provide n explanation that is sourced from SO, that code and explanation might very well be flawed as well. **Automating this process likely increases the velocity with which those security flaws spread** even more. It will also cement the code that is written today as the de-facto standard way of writing code in the future and significantly slow down the speed at which old, outdated practices are phased out. Although I do not like the term ["cargo-cult programming"](https://en.wikipedia.org/wiki/Cargo_cult_programming), the Wikipedia article for it aptly describes the problem of blindly following patterns and copying them without understanding why and where they might be appropriate, creating code that is deeply flawed in the process. We have already seen the problem prior to the advent of AI-assisted code copiloting, and there is a high likelihood that AI suggestions are all too often applied too eagerly without understanding if they are appropriate in that context.

This leads us to the last paper and the important question of how we get rid of those patterns, how we develop new ways to write code and how we can still drive **innovation** and novel paradigms to write code in when faced with a high degree of automation and large amounts of code that are written with the assistance of AI code copilots?

And it doesn't look good that that front, either. 

The last study I cited [^2] shows that there is what they call a "model collapse" when re-training LLMs on their own outputs, i.e. code generated by themselves as part of an code-copilot. The capabilities of LLMS diminish the more they are trained on their own outputs, making genuine human inputs to retrain them on invaluable for the future. But the problem is that text written by LLMs cannot reliably be distinguished from text written by humans. Unless there is a major theoretical breakthrough, this means that with higher and higher adoption levels of AI-assisted code-copilots, more and more inputs to these systems will likely be AI generated, unless one starts the painstaking process of curating code and text that is verifiably written by humans alone. 

The authors write "[...] over time we start losing information about the true distribution, which first starts with tails disappearing, and over the generations learned behaviours start converging to a point estimate with very small variance. Furthermore, we show that this process is inevitable, even for cases with almost ideal conditions for long-term learning i.e. no function estimation error. [...] Finally, we discuss the broader implications of model collapse. We note that access to the original data distribution is crucial: in learning where the tails of the underlying distribution matter, one needs access to real human-produced data. In other words, the use of LLMs at scale to publish content on the Internet will pollute the collection of data to train them: data about human interactions with LLMs will be increasingly valuable."[^2]

The details of the study do not matter much in the context of this blog article, but the above paragraphs should give rising concern as to where we are heading in terms of future LLMs.

## Conclusion

So where are we headed in the next 5-20 years? Honestly, I don't know. At least in Europe, there is an increasing demand for regulation of software development because the economic damages of software failures and security holes skyrocket. Thus far, we as a field haven't done a good job at pro-actively design those regulations, with much of the industry being very much against it. AI offers great increases in productivity, but also comes with additional demand on verification and quality assurance. Thus far, adoption rates far outpace the speed at which we can learn to responsibly use these technologies and mitigate their short-term and long-term impacts. There is already talk about AI regulation, driven mainly by economists and law-makers, and we computer scientists and also software developers need to make sure out voices are heard in order to ensure that the regulation we will eventually get is reasonable and sound and does increase software quality and security, and doesn't just cost a lot of money in paperwork and cover-your-ass actions.

We should also be wary were software development as a whole is headed, how we still drive innovation and make sure AI assisted code-copilots are a sustainable, safe and high-quality tool hat is able to stick around for a long time. This will involve better quality assurance of those tools as well as strategies for innovation and re-training of these models to allow programming to still evolve in the future and not approach a fixed point.

[^1]: https://sostats.github.io/last30days/
[^2]:  [The Curse of Recursion: Training on Generated Data Makes Models Forget](https://arxiv.org/abs/2305.17493) (2023) by Ilia Shumailov, Zakhar Shumaylov, Yiren Zhao, Yarin Gal, Nicolas Papernot and Ross Anderson
[^3]: [Do Users Write More Insecure Code with AI Assistants?](https://arxiv.org/abs/2211.03622) (2022) by Neil Perry, Megha Srivastava, Deepak Kumar and Dan Boneh
[^4]:  [Existence of Stack Overflow Vulnerabilities in Well-known Open Source Projects](https://arxiv.org/abs/1910.14374) (2019) by Md. Masudur Rahman and B M Mainul Hossain