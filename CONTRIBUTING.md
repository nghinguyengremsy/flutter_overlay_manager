# Contributing

Hello, We're glad to have a contributor like you here.  
This file is intended to be a guide for those who are interested in contributing to the Flutter Overlay Manager.

## Before Modifying the Code

If the work you intend to do is non-trivial, it is necessary to open
an issue before starting writing your code. This helps us and the
community to discuss the issue and choose what is deemed to be the
best solution.

### Mention the related issues:
If you are going to fix or improve something, please find and mention the related issues in [CHANGELOG.md](#changelog), commit message and Pull Request description.
In case you couldn't find any issue, it's better to create an issue to explain what's the issue that you are going to fix.

## Let's start by our overlay architecture

We have an Overlay widget that helps us move the main UI, including navigation, to another layer. We can add any other layers without affecting the main UI.


## Keep your branch updated

While you are developing your branch, It is common that your branch gets outdated and you need to update your branch with the `dev` branch.
To do that, please use `rebase` instead of `merge`. Because when you finish the PR, we must `rebase` your branch and merge it with the dev.
The reason that we prefer `rebase` over `merge` is the simplicity of the commit history. It allows us to have sequential commits in the `dev`
[This article](https://www.atlassian.com/git/tutorials/merging-vs-rebasing) might help to understand it better.


## Creating a Pull Request

Now you have to
submit a pull request (or PR for short) to us. These are the steps you should
follow when creating a PR:
 
- Make a descriptive title that summarizes what changes were in the PR.

- Mention the issues that you are fixing (if doesn't exist, try to make one and explain the issue clearly)

- Change your code according to feedback (if any).

After you follow the above steps, your PR will hopefully be merged. Thanks for
contributing!