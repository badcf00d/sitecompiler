# sitecompiler
sitecompiler is a suite of several minifiers, general purpose compressors, and image & video optimisers and encoders. It supports web content such as `.html` `.css` and `.js`, image file types such as `.png` `.jpg` `.gif` `.svg` and `.webp`, general purpose brotli and zopfli file compressors for producing `.gz` and `.br` files, as well as support for encoding video files contained in `.mkv` `.mp4` `.webm` into the recently released AV1 video codec. 

#### Using sitecompiler:

 - sitecompiler does not alter any existing files, it will only create new compressed versions of existing files so that development work can continue to be done on the original files, and then compressed for deployment. 

 - To make use of the compressed `.br` and `.gz` files produced by sitecompiler, the web-server may need some additional configuring to serve the compressed content. 
   - In nginx, this involves adding the `gzip_static on;` flag to serve the `.gz` files, and the `brotli_static on;` flag to serve the `.br` files in versions of nginx that been compiled with https://github.com/google/ngx_brotli. 
   - In Apache this is a bit more of a faff but there are some good tutorials around if you search for something like "Apache static compression".

 - To make use of newer image & video codecs you may need to make some changes to the web content itself, especially when trying to maintain compatability for devices that do not support them.
   - Making use of webp images is relatively simple:
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
