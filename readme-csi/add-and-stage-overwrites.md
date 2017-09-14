# Staging an overwrite

Staging an overwrite--that is, viewing it on [review.docs.microsoft.com](https://review.docs.microsoft.com) before publishing it publicly--is done using the same procedure as performed in the [azure-docs-pr](https://github.com/Microsoft/azure-docs-pr) repository. At a high level, that process is:

1. **Fork** the Microsoft/Azure reference repository to your GitHub account
2. **Clone** your fork locally
3. Create an **upstream** remote that points to the Microsoft/Azure reference repository
4. Create a **branch** in your local clone
5. Add/edit your overwrites
6. **Push** to your fork (a.k.a "origin")
7. On [github.com](http://github.com), issue a **pull request (PR)** into the master branch of the reference repo (a.k.a. "upstream"). After a time, you'll recieve an email containing **staging links** for your modified content
8. **Repeat steps 5-6** as necessary--you'll get a new staging link email each time you push to your remote branch (origin)
9. When you're ready to have your PR merged, add a comment to your PR containing `#sign-off`. This removes the **do-not-merge** tag from your PR and adds the **ready-to-merge** tag. This puts it into the queue for review by the PR reviewers, who will do so, and merge into master if all looks good.

For more details on the preceding operation, please see the following two articles in the Contributor's Guide:

* [Install and set up tools for authoring in GitHub](https://github.com/Microsoft/azure-docs/blob/master/contributor-guide/tools-and-setup.md)
* [Git commands for creating a new article or updating an existing article](https://github.com/Microsoft/azure-docs/blob/master/contributor-guide/git-commands-for-master.md)

> [!TIP]
> You can find more information about overwrites in the [DocFx documentation](https://dotnet.github.io/docfx/tutorial/intro_overwrite_files.html).
>

## Troubleshooting

If you feel like you're stuck in a trial-and-error mode, throwing @#$%^ at the wall and it's not sticking, check out some of the solutions to common problems below. 

NOTE: This section is intended to help with overwrite-specific issues, not necessarily common Markdown issues. For Markdown help, see the [Markdown section in the Docs Contributor Guide](https://stage.docs.microsoft.com/en-us/contribute/markdown), or the [OPS User Guide](https://opsdocs.azurewebsites.net/en-us/opsdocs/partnerdocs/gfm?branch=master).

### Issue: My list is not rendering correctly.

For example, sometimes when you do an overwrite of an item (say, a description), you need to use the "*content" keyword to do more than just overwrite a few words or single line. Sometimes you want to do a whole block of Markdown text, with an unordered list, like this: 

```
description: *content
---

## Test
- bullet 1  
- bullet 2  
- bullet 3  

```

But when the Markdown renders, it ends up looking something like this, where your bullets are misaligned with the text above them:

<b>Test</b>
<li>bullet 1</li>
<li>bullet 2</li>
<li>bullet 3</li>

At this point, there is no solution. We are exploring this with the VSC team and have filed a bug (https://mseng.visualstudio.com/DefaultCollection/VSChina/_workitems?_a=edit&id=801775). We will update as soon as we know more.

**UPDATE:** As of 12/15/16, this has been resolved. Please reopen the bug above if you find differently, or find other/related issues with list items. 

### Issue: I can't get *anything* to show for my overwrite. In fact, none of my overwrites seem to work for a given .md file, or they just stop at a certain point.

**Extraneous (`:`) colon character**  
A common cause of this is due to a colon being used in the overwrite text. This is because the overwrite file syntax uses the YAML format to express the name/value pairs, and YAML specifies a single colon per line to separate the overwrite name/value pair.

For example, if you have a overwrite that looks like the following, the extraneous `:` in the description for the `api-version` parameter overwrite will cause an exception in the build and none of your overwrites will be applied to the final page/output.

```
---
uid: management.azure.com/RateCardManagementClient/2015-06-01-preview/RateCard_Get
parameters:
    - name: api-version
      description: Use the latest version: `2016-08-31-preview`.
    - name: subscriptionId
      description: The identifier of the target Azure subscription. 
description: *content
---
```

**Extraneous `---` separator** in a overwrite  
As with other issues, this is about making sure you have valid YAML. If your description overwrite contains extra `---` delimiter at the end for example (like the one below), this will also cause an exception in the build and none of your overwrite will be applied to the final page/output.

```
---
uid: management.azure.com/RateCardManagementClient/2015-06-01-preview/RateCard_Get
description: *content
---
<content>
---
<EOF > 
```

### Issue: My exception overwrite is not working.
For example, the following will not overwrite the text for the specified exception:

```
---
uid: Microsoft.ServiceBus.Messaging.TopicDescription.EnableFilteringMessagesBeforePublishing
exceptions: *content
---
[NoMatchingSubscriptionException](/dotnet/api/microsoft.servicebus.messaging.nomatchingsubscriptionexception)

Thrown if no subscriptions are found.
```

Instead, you need to use one the following formats:

```
---

uid: Microsoft.ServiceBus.Messaging.TopicDescription.EnableFilteringMessagesBeforePublishing
exceptions: 
- type: Microsoft.ServiceBus.Messaging.NoMatchingSubscriptionException 
  description: Thrown if no subscriptions are found.
---
```
 
Or:

```
---

uid: Microsoft.ServiceBus.Messaging.TopicDescription.EnableFilteringMessagesBeforePublishing
exceptions: 
- type: Microsoft.ServiceBus.Messaging.NoMatchingSubscriptionException
  description: *content
---
Thrown if no subscriptions are found.

```
