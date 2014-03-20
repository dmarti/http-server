# A simple Capstan example #

[Capstan](https://github.com/cloudius-systems/capstan) is a new tool for building [OSv](http://osv.io/) virtual machine images.  If you have worked with other tools for making VMs, you'll find that Capstan is really simple.  It's a lot like [Docker](http://www.docker.io/) actually&mdash;only you get a complete VM out of it and not just a container.

You're probably used to blogs from sneaky tech evangelists who claim that something is simple and then post some [complicated set of instructions](http://drusepth.net/how-to-speed-up-your-computer-using-google-drive-as-extra-ram/).  So just to keep your finger off the close button, here's all you need to do.

* Add a Make target to build your application as a shared object.

* Write a short Capstanfile.  (8 lines not counting comments).

* Run Capstan.

That's all there is to it.  Finger off the close button now?  Good.  Ready?  Let's make a VM that does something useful, say, serve this article to the entire Internet.  Go ahead and `git clone` [Capstan](https://github.com/cloudius-systems/capstan) and follow along.

## An easy example, plus Makefile work ##

Just to keep it simple, let's borrow the short HTTP server example from [libevent](http://libevent.org/).  The libevent project is a wrapper for convenient event-driven programming, and the library is used in high-profile projects such as [Tor](https://www.torproject.org/), the anonymous communications system, and [Chromium](http://www.chromium.org/Home), the basis for the Google Chrome web browser.

Best of all, libevent includes an easy-to-use HTTP implementation and sample code for using it.  So I'll copy their web server sample code, tweak it a little to make the web server I need, and set up a simple Makefile.

You'll need the development package for libevent installed.  On my system, it's called `libevent-devel`.

Here's the target to pay attention to:

```
http-server.so : http-server.c
        $(CC) -o $@ -std=gnu99 -fPIC -shared -levent $``
```

Yes, that's right, we're using `-fPIC` (position independent code) and `-shared` (passed to the linker, make it build a shared library).  And `http-server.c` has a function called `main`.  What's going on?  This is because of the way OSv works.  Your application on OSv isn't a conventional ELF executable, but a .so file.

Besides building the actual HTTP server, I'll also put in a Make target to create the HTML version of this article from the README, [because I can](https://lwn.net/Articles/589196/).  So I type `make` to build the web content and the web server.

Of course you can expand on this to build as complicated of an application and data set as you want.  This is just an example to show you Capstan for now.

## Step two: Add a Capstanfile ##

Now it's time to tell Capstan how to create the virtual machine image.  Building it is easy--just run `make`--so there's the `build` section right there.  Now we need to tell Capstan what files go into the image, so we populate the `files` section with the name of our web server (http-server.so) the libevent shared library, and some web content--just the HTML version of this article, plus a favicon.ico file.  (For now I'm just copying my development systems's copy of libevent into the image.  For real use, I'll come up with a more consistent way to keep track of build artifacts like this, probably borrowing them from some helpful Linux distribution.  Yes, OSv can use libraries built on and for your 64-bit Linux box.)

Easy so far.  Now for the `cmdline` option, which is like [Docker's CMD](http://docs.docker.io/en/v0.6.3/use/builder/#cmd): the command that gets run when the image starts.  The HTTP server just takes its DocumentRoot entry from the command line, so the command comes out as:

```
cmdline: /tools/http-server.so /www
```

There's one more section in the Capstanfile: `base`.  That's a pre-built OSv image, currently hosted in Capstan author [Pekka Enberg's GitHub account](https://github.com/penberg).  (Yes, OSv is so streamlined that an entire VM image will fit in under the [GitHub file size limit](https://github.com/blog/1533-new-file-size-limits), with room to spare.)

## Putting it all together ##

Now, when we type `capstan build`, Capstan invokes `make`, then creates the VM image.  It lives under `.capstan` in your home directory, at:

```
.capstan/repository/http-server/http-server.qemu
```

This is a QCOW2 image, ready to run under KVM or convert to your favorite format.  That's it.  Told you it was simple.  You can just do `capstan run` and point your browser to [http://localhost:8080/](http://localhost:8080/) to see the site.

In an upcoming blog post, I'll cover the recently added VirtualBox support in Capstan (hint: trry `-p vbox`) and some other fun things you can do.

If you have any Capstan questions, please join the [osv-dev mailing list on Google Groups](https://groups.google.com/forum/#!forum/osv-dev).  You can get updates on new OSv and Capstan progress by subscribing to this blog or folllowing [@CloudiusSystems](https://twitter.com/CloudiusSystems) on Twitter.

