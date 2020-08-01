# sitecompiler
![](https://raw.githubusercontent.com/badcf00d/sitecompiler/master/Benchmark.png)
sitecompiler is a Makefile that uses a suite of several minifiers, general purpose compressors, and image & video optimisers and encoders to compress websites. It supports web content such as `.html` `.css` and `.js`, image file types such as `.png` `.jpg` `.gif` `.svg` and `.webp`, general purpose brotli and zopfli file compressors for producing `.gz` and `.br` files, as well as support for encoding images & videos into the AV1 codec, producing `.avif` and `.webm` files respectively. 

#### Quick start
 - I'll answer a question you probably have first off - sitecompiler does not alter any existing files, it will only create new compressed versions of those files so that development work can continue to be done on the original files, and then compressed for deployment.
   - The only case where files may be unintentially overwritten is if you have image files with with different extensions but the same name in a directory, but the contents of those files are _not_ the same. E.g. if you have a directory with image.jpg, and image.webp, sitecompiler will assume those are meant to be the same image, and if image.jpg is newer than image.webp, image.webp will be overwritten with a compressed version of image.jpg.
 - Run `make depend` to update or install any dependencies that might be needed.
 - `make` will run the default recipe which is `webcontent` which processes `.html` `.css` and `.js` files, once sitecompiler is done you will have a `*.gz` and `*.br` version of all the web content files in your website that should be significantly smaller than they were originally. 
   - The first time you run site compiler it will ask for the directory of your website, enter `.` for the current directory.
   - As with all `make` things, run `make -jN` with `N` being the number of jobs to run in parallel for more fastness.
 - When you update any the files in your website, run `make` again and the new files will be processed.


#### More options
 - `make webcontent` processes `.html` `.css` and `.js` files, to do these file types individually run make with the corresponding file type such as `make html`
 - `make all` processes all the file types implemented in sitecompiler, those being all the web content files, image & video files, and miscellaneous files.
 - `make images` processes image file types `.png`, `.jpeg`, `.jpg`, `.gif`, `.svg`, `.webp`, to do these file types individually run make with the corresponding file type such as `make png`.
 - `make misc` processes miscellaneous file types: `.txt`, `.xml`, `.csv`, `.json`, `.bmp`, `.otf`, `.ttf`, and `.webmanifest`.
 - `make clean` deletes all of the `.gz`, `.br`, and `.min` files that sitecompiler produces when processing all file types.
 - `make clean-webcontent` deletes all of the `.gz`, `.br`, and `.min` files that sitecompiler produces when processing the web content file types.
 - `make clean-images` deletes all of the `.gz`, `.br`, and `.min` files that sitecompiler produces when processing all image file types.
 - `make size` displays some useful statistics about the size of files pre, and post compression.
 - `make depend` runs the `dependencies.sh` script to install dependencies for sitecompiler.
 
 

 #### Using files produced by sitecompiler
 - To make use of the compressed `.br` and `.gz` files produced by sitecompiler, the web-server may need some additional configuring to serve the compressed content. 
   - In nginx, this involves adding the `gzip_static on;` flag to serve the `.gz` files, and the `brotli_static on;` flag to serve the `.br` files in versions of nginx that been compiled with https://github.com/google/ngx_brotli. 
   - In Apache this is a bit more of a faff but there are some good tutorials around if you search for something like "Apache static compression".

 - To make use of newer image & video codecs you may need to make some changes to the web content itself, especially when trying to maintain compatability for devices that do not support them.
   - Making use of webp images is relatively simple such as what's shown [here](https://css-tricks.com/using-webp-images/)
     - In HTML you can use the `<picture>` and `<source>` attributes like this to serve either the jpg or webp depending on what the client supports
       ```
       <picture>
           <source srcset="images/picture.webp" type="image/webp">
           <img src="images/picture.jpg" alt="Pretty Picture"> 
       </picture> 
       ```
     - In CSS you can use `modernizr` and include `.webp` and `.no-webp` versions of styles like this to serve either the jpg or webp depending on what the client supports
       ```
       .no-webp .style-image {
           background-image: url("image.jpg");
       }

       .webp .style-image {
           background-image: url("image.webp");
       }
       ```
#### Future work
 - Currently the `dependencies.sh` script mainly relies on `apt-get`, and so only fully work on debian-based systems, but this wouldn't be too difficult to change in the future.
 - Audio encoding into the Opus format would be a nice to have
 - CI for testing
