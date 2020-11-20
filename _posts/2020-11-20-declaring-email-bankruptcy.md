---
title: Declaring Email Bankruptcy
description: My journey at taming the flood that is email. How I'm going to stop seeing spam, and get more sanity around my email.
---
*Disclaimer: This strategy really only works for personal email or if you're a solo developer. Why that is will become obvious below. It can be adapted to small businesses using subdomains but I haven't outlined that here.*

## Where I'm at Today
Email sucks. My primary email address, me@bryanculver.com, has been used for anything and everything since the day I registered it in 2006. That email address is now almost as old as I was when I registered it. In that time there have been countless compromised websites, sold mailing lists, one-time downloads, missed "Sign-up for updates" check boxes, app registrations... And in that same time I've moved between email providers a couple of times, finally settling on Google. Google's spam filtering to this day is unprecedented. But what it can't stop is legitimate emails, or new newsletters.

## Taping the Screen Door
For many years I've tried several different ways to tame the firehose that is email: aggressive filtering, inbox purging, "flag as spam" barrages. However like a screen door on a submarine, there isn't enough duct tape to go around to stem the leak. Within a month or two I'm back to an unmanageable inbox. The main issue is that even though I could plug the old leaks (unsubscribe to mailing lists I no longer needed, "send to spam" outright junk), my email address is out there being shared between advertising bots.

I could stop this by registering a new email address but then I'd be in migration hell. "Hey everyone, my email address is now email@bryanculver.com! Please contact me there!" But it's never fun to be on the receiving end of that email, let alone reminding people when they haven't updated your contact. 

I recently tried out the [HEY](https://hey.com) service from the creators of Basecamp. I forwarded my email address to my @hey.com email address for a few weeks. It is an amazing product and I would say before you follow the steps I'll outline below, you should check it out. Their approach to email filtering puts it front and center as a regular habit, which keeps the chore burden to a minimum. Besides, I get a feeling Basecamp is a group of people who REALLY dislike a messy and noisy inbox. 

I decided not to continue using HEY for a few reasons: I wanted total control over my email (their "bring your own domain" offering isn't available yet, more on that in a moment), need to leverage many aliases, and the 3 different "categories" of emails didn't work for how I use emails. While forwarding from my domain to @hey.com would have worked, it would have been clunky for replies and had a hard dependency on two email addresses.

So I couldn't outright abandon me@bryanculver.com. I still love that email address and I love giving it out. It's also not everyone I interact with every day's problem to fight my spam for me. And any new address I come up with will eventually have the same amount of flood as my existing one.

## Developing a New Approach
Security and privacy have bubbled up higher in my priority list as of late[^1]. I'm a firm believer that you should pay for the products you use every day, because if it's free you're the product. That's why I've payed for G Suite (wait... Google Apps... no... Google Workspaces? I think that's it) for many years after exiting beta. But Google has shown over the years that their thirst for data will likely never be satiated. I doubt they groom paid customers emails, but emails are inherently plain text (GPG, I love you but no), even if they are transported in TLS. Who's to say drive-by "anonymous" statistics collections doesn't happen after unwrapping TLS before dropping it off in the inbox?

I've always accepted this risk because I've ran with my own domain name. Not only is having your own domain name a bit of geeky bling but it gives the flexibility for you to relocate to another email host at a moment's notice, even if it's your own. But since everyone knows my email address, I now have a target on my inbox: domain takeover.

Am I a high-value target? No. But I've seen numerous account takeovers from even the most security concerned people on the Internet. Bots don't target people based on their profile, they go the buck-shot approach, and otheraddress@bryanculver.com would be as vulnerable as me@bryanculver.com for an MX record take over. Also, [SPF/DMAR spoofing on Google](https://ezh.es/blog/2020/08/the-confused-mailman-sending-spf-and-dmarc-passing-mail-as-any-gmail-or-g-suite-customer/) is a thing! Dratz... it looks like I'll need another domain with another address.

But I don't have to tell everyone about it...

## More, Smaller Screen Doors
Having another big screen door (newemail@newdomain.biz) would expose the same spam reseller problem as my existing account. Google has helped out a lot by making more common the use of the user+something@domain.com, which sends to the same address as user@domain.com. However websites don't all agree to support this. I've found several websites that outright reject this format. You also can't readily email out with this format and if you ever need to contact a company about your account, you sometimes have to explain to them why the email addresses don't match.

That's where alias come in. If you do pay for your email hosting and bring your own domain, it is likely trivial to setup aliases. You can have email@, social@, newsletter@, spam@ all point to the same inbox. You can also set up the ability to email out and reply-as these email addresses as well. Neat!

Both strategies allow you to set up much smarter filters. Companies switch their subject formats, mailing list services, or from addresses all the time. Instead you can create a filter like "from:junkbook@domain.com OR from:email+junkbook@domain.com" and send it straight to trash.

But then there is the clunkiness of going into an admin panel, setting up the alias, doing all the configuration before you sign up for a new site or service. The more steps in a process, the more likely you are to skip it. "Well these are all close enough so I'll just toss them in here". This is what's nice with the +something model is that you get it for free, without any steps.

This is where a catch-all comes into play! I don't ALWAYS need to be able to email out as a different user@, only sometimes. Using a catch-all I can have every email that doesn't match a given alias come into the same inbox. Some services let you reply to inbound emails on aliases without registering one. Sometime in the future however if I need to be able to start a new email, I can register the address as an alias and continue on my way. Seamless to the service I'm interacting with, and almost no steps for me.

## What I Implemented
I needed a new domain, and I preferred to have a new email hosting provider, although I likely could have done this as a separate user in my existing Google Workspace account.

I registered my domain name with [Hover](https://hover.com/Eb9rHUeO)[^2] and set up an account at [Fastmail](https://ref.fm/u25244480)[^3].
Why Hover and Fastmail?

For Hover, I have always loved that they bundle in WHOIS privacy by default. It is pricier for that but it takes the guess work out and part of my new strategy is that my new domain is my "important" domain and I would like to keep its exposure to an ABSOLUTE minimum. I have had great support interactions with their team in the past.

For Fastmail, I've done research of different reputable hosting providers. ProtonMail was high up on that list and should be a consideration for people with even tighter privacy concerns than mine, however I like the native iOS mail app and I know to get true secrecy with Protonmail I had to use their app. Plus their public dedication to secrecy made me feel like a higher drive-by target. There are people I know and respect that use Fastmail and swear by it.

I won't walk you through the scope of registering for these services and connecting a domain to a email provider because honestly Fastmail's onboarding wizard can do that for you even better than I. What I can show you is how I've configured it after that step.

There's nothing fancy on the domain side except for defining MX records for the `*` hostname record along with the required `@` hostname record. This isn't essential for how I ended up using the service but if you want to leverage subdomain filtering it is required to make it work.

In Fastmail, under the "Users & Aliases" section of the admin panel you'll want to make sure you have "*&yourdomain.com" forwarded to your account that you registered.

![Fastmail User & Aliases Screenshot](/assets/images/fastmail-alias.jpg)

Should you want to email outbound in the future, define a new alias to go to the same inbox and you can now email outbound from that address.

Now I can port my existing services to my new, more trusted and controlled inbox. And If I ever get concerned about Fastmail, I can update my MX records to point to another server and continue receiving my emails without changing anything on the services I use or worry about a "confirm email change" link.


## What About Existing Email
Like I said, I don't want to abandon me@bryanculver.com. But how am I going to adopt this new email and minimize spam on my existing.

I will be moving all important accounts (I won't define that here 😁) over to my new account, with each as a separate user. How would that look?

- scambook@domain.org
- bitter@domain.org
- buythethingsazon@domain.org
- ...

There will be no need for me to adjust Fastmail as I port these services over, now or in the future. Should (read: when) one of these services sell my information in the future, it will be obvious which one of them has. I can mark the alias as a blackhole, and update that service to a new email (scambook2-electric-boogaloo@domain.org). Rinse and repeat. Or I can outright stop using the service because they don't care about my sanity.

And what about me@bryanculver.com? I will be switching to an allow-listed setup on this email. "Important" emails in this inbox will require to be one of my contacts. I can routinely peruse the "Other" folder for new connections but at my leisure. I'll likely leave this on Google as well, as Google learning about the spam I get doesn't affect me much but learning about the services I do pay for or are important to me does. Additionally as my primary human communication email address, having Google Calendar attached is a bonus.

Now, could I have done this without registering for a new service or a new domain? Absolutely. You can do this today if you have your own domain and paid email hosting. However minimizing exposure was an important consideration for me but may not be for you.

My tinfoil hat is multi-ply.

---


[^1]: Another great thing HEY has is exceptional tracking blockers that I will miss.
[^2]: $2 off your first purchase if you click the link!
[^3]: 10% off your first year if you click the link!