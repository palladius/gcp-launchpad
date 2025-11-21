## context

We have a program in Cloud devrel: 'Onramp'. We aim to give people free credits to try out GCP.
For security, we have ever-changing URLs, like https://trygcp.dev/claim/h2-labs-milano25. The
claimed URL is open on a time period, and allows people to access this.
This is an easy thing, most of the time, but there can be issues, which is why we have a Google Slides deck explain it.

The slides can be found under `rag/`.

## Coding

Coding MUST use the `reveal.js` framework. This should be easy as this repo is a CLONE of it, so you can just look around
for code, example and docs!

## The job

I need you to transform the current slides in a "online reveal.js Slide deck", using `reveal.js` framework.

The site will be mostly static, except for very few things:
1. The CreditReclaim URL - say https://trygcp.dev/claim/h2-labs-milano25
2. Some enhancements, like a Title, an emoji, and some additional description.
3. The togglability of the tutorial, see "Slides sub-chapters".

Your first job is to extract content from the Google Slides in a SMART way (text + images), not just a screenshot. Of course we can START with a screenshot, and we can refine later.

## Publishing

We will then publish this website as github pages.

The idea is that i can launch the website with some sort of querystring parameter or having a YAML/JSON config in the home (easy to edit) so i can serve multiple events.
The ultimate need is, I want to be able to publish "two" pages at the same time and give a single perma-url to my people, 100 people in Milan, 100 in Toronto, and be able to feed them different pages.

1. One option could be to use Querystring
2. Another option would be to branch the repo for every event, and
3. Maybe you have another/better idea?

## Slides sub-chapters

Slides sub-chapters should be **togglable**.

I want to be able to say:
* [yes/no] Add the Onramp pages (default yes)
* [yes/no] Add the Gemini CLI installation pages (default no)
* [yes/no] Add the AntiGravity pages (default no)
* [yes/no] Add the Gemini API Key downloading pages (default no)

This should be also part of the configuration yaml/json

## Onramp URL

This is the most important part, which I want from version 1.0. should be something like this:

```html
<!-- pseducode - dont take it literally! -->
{{ if onramp_url == '' }}
 <div class='redflag'>
   Sorry, to do this codelab you need to be given a URL from a Google expert. Blah blah
 </div>
{{ else }}
  Get credits at <a href=""></a>
  <img src=".." /> <!-- QR Code for this URL -->
{{ endif }}
```

A QR code should be generated for each URL, possibly only once (build time, not render time) but I'm flex.
QR code can wait for v2.

## Swim lanes

* I will run NPM foreground job, via `just onramp` which indirectly calls some `npm start <xxx>` we maintain.
* You will make sure it logs STDOUT under some `log/` folder and will look it up.
* You do the coding, and error checking.
* We can both navigate to localhost:8080
  * You can check basic functionality. Note you should be able to navigate through cursors (left and right to change slide).
  * I can check more sophisticated imagery and look and feel.

## Testing

* The final product should look loyal to the original:
  * Page 1 of the rendered page should have same text and same images as slide 1 in `rag/public-slides/`

## URLs

* Web page: trygcp.dev
* Slide Deck: https://docs.google.com/presentation/d/1kGxf44SddFt4jUJJuMLlXwezgdX4352Q49Jwqg50u0E/edit?slide=id.g3445d1a3424_0_438&pli=1#slide=id.g3445d1a3424_0_438
