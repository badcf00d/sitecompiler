space:= 
space+=
SHELL:=/bin/bash


CURRENT_PATH := $(subst $(lastword $(notdir $(MAKEFILE_LIST))),,$(subst $(space),\$(space),$(shell realpath '$(strip $(MAKEFILE_LIST))')))
SITE_PATH := $(shell cat $(CURRENT_PATH).site.path 2>/dev/null)

ifeq ($(strip $(SITE_PATH)),)
    userInput := $(shell read -p "Enter directory of web site (can be relative or absolute): " userInput; echo $$userInput)
    $(info Saving site path to $(CURRENT_PATH).site.path)
    SITE_PATH := $(shell realpath $(userInput))
    $(shell echo $(SITE_PATH) >> $(CURRENT_PATH).site.path)
endif

HTML := $(info Finding HTML files...) $(shell find $(SITE_PATH) -name '*.html' | perl -p -e 's/ /\\ /g')
HTML_BR := $(HTML:%.html=%.html.br) 
HTML_GZ := $(HTML:%.html=%.html.gz)
HTML_MIN := $(HTML:%.html=%.html.min)
HTML_FLAGS := --collapse-whitespace \
				--collapse-inline-tag-whitespace \
				--collapse-boolean-attributes \
				--remove-comments \
				--remove-optional-tags \
				--remove-redundant-attributes \
				--remove-script-type-attributes \
				--remove-tag-whitespace \
				--use-short-doctype \
				--sort-attributes \
				--sort-class-name \
				--minify-css true \
				--minify-js true

CSS := $(info Finding CSS files...) $(shell find $(SITE_PATH) -name '*.css' | perl -p -e 's/ /\\ /g')
CSS_BR := $(CSS:%.css=%.css.br)
CSS_GZ := $(CSS:%.css=%.css.gz)
CSS_MIN := $(CSS:%.css=%.css.min)


JS := $(info Finding JS files...) $(shell find $(SITE_PATH) -name '*.js' | perl -p -e 's/ /\\ /g')
JS_BR := $(JS:%.js=%.js.br)
JS_GZ := $(JS:%.js=%.js.gz)
JS_MIN := $(JS:%.js=%.js.min)
JS_FLAGS := --compress --mangle


PNG := $(info Finding PNG files...) $(shell find $(SITE_PATH) -name '*.png' | perl -p -e 's/ /\\ /g')
PNG_GZ := $(PNG:%.png=%.png.gz)
PNG_BR := $(PNG:%.png=%.png.br)
PNG_MIN := $(PNG:%.png=%.png.min)


JPEG_GZ := $(info Finding JPEG files...) $(shell find $(SITE_PATH)  \( -name '*.jpeg' -o -name '*.jpg' \)  | perl -p -e 's/ /\\ /g' | perl -p -e 's/\n/.gz\n/')
JPEG_BR := $(JPEG_GZ:%.gz=%.br)
JPEG_MIN := $(JPEG_GZ:%.gz=%.min)


GIF := $(info Finding GIF files...) $(shell find $(SITE_PATH) -name '*.gif' | perl -p -e 's/ /\\ /g')
GIF_GZ := $(GIF:%.gif=%.gif.gz)
GIF_BR := $(GIF:%.gif=%.gif.br)
GIF_MIN := $(GIF:%.gif=%.gif.min)


SVG := $(info Finding SVG files...) $(shell find $(SITE_PATH) -name '*.svg' | perl -p -e 's/ /\\ /g')
SVG_GZ := $(SVG:%.svg=%.svg.gz)
SVG_BR := $(SVG:%.svg=%.svg.br)
SVG_MIN := $(SVG:%.svg=%.svg.min)


WEBP := $(info Finding WEBP files...) $(shell find $(SITE_PATH) \( -name '*.webp' -o -name '*.jpeg' -o -name '*.jpg' -o -name "*.png" \)  | perl -p -e 's/ /\\ /g' | perl -p -e 's/jpeg|jpg|png/webp/g')
WEBP_GZ := $(WEBP:%.webp=%.webp.gz)
WEBP_BR := $(WEBP:%.webp=%.webp.br)
WEBP_MIN := $(WEBP:%.webp=%.webp.min)


AV1 := $(info Finding AV1 files...) $(shell find $(SITE_PATH) \( -name '*.mkv' -o -name '*.mp4' -o -name '*.webm' \)  | perl -p -e 's/ /\\ /g' | perl -p -e 's/webm/av1.webm/g' | perl -p -e 's/mkv|mp4/webm/g')


MISC_TYPES := -name '*.txt' \
                -o -name '*.xml' \
                -o -name '*.csv' \
                -o -name '*.json' \
                -o -name '*.bmp' \
                -o -name '*.otf' \
                -o -name '*.ttf' \
                -o -name '*.webmanifest'

MISC_BR := $(info Finding miscellaneous files...) $(shell find $(SITE_PATH) \( $(MISC_TYPES) \) | perl -p -e 's/ /\\ /g' | perl -p -e 's/\n/.br\n/')
MISC_GZ := $(MISC_BR:%.br=%.gz)






.INTERMEDIATE: $(HTML_MIN) $(CSS_MIN) $(JS_MIN) $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN)
.PHONY: all size depend clean clean-webcontent clean-images misc webcontent html js css images png jpeg gif svg webp av1
#.SILENT:


webcontent: $(HTML_GZ) $(HTML_BR) $(CSS_BR) $(CSS_GZ) $(JS_BR) $(JS_GZ)
html: $(HTML_GZ) $(HTML_BR)
js: $(JS_BR) $(JS_GZ)
css: $(CSS_BR) $(CSS_GZ)

images: $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP_GZ) $(WEBP_BR) 
png: $(PNG_GZ) $(PNG_BR)
jpeg: $(JPEG_GZ) $(JPEG_BR)
gif: $(GIF_GZ) $(GIF_BR)
svg: $(SVG_GZ) $(SVG_BR)
webp: $(WEBP_GZ) $(WEBP_BR) 
av1: $(AV1)

misc: $(MISC_BR) $(MISC_GZ)
all: $(HTML_GZ) $(HTML_BR) $(CSS_BR) $(CSS_GZ) $(JS_BR) $(JS_GZ) $(MISC_BR) $(MISC_GZ) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP_GZ) $(WEBP_BR) $(AV1)



#
# HTML
#
.SECONDEXPANSION:
%.html.br: $$(subst $$(space),\$$(space),%).html $$(subst $$(space),\$$(space),%).html.min
	$(info HTML Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.html.gz: $$(subst $$(space),\$$(space),%).html $$(subst $$(space),\$$(space),%).html.min
	$(info HTML Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.html.min: $$(subst $$(space),\$$(space),%).html
	$(info HTML Minifier: $@)
	@html-minifier $(HTML_FLAGS) "$<" -o "$<.min"



#
# CSS
#
.SECONDEXPANSION:
%.css.br: $$(subst $$(space),\$$(space),%).css $$(subst $$(space),\$$(space),%).css.min
	$(info CSS Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.css.gz: $$(subst $$(space),\$$(space),%).css $$(subst $$(space),\$$(space),%).css.min
	$(info CSS Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.css.min: $$(subst $$(space),\$$(space),%).css
	$(info CSS Minifier: $@)
	@cleancss -O2 -o "$<.min" "$<" 



#
# JavaScript
#
.SECONDEXPANSION:
%.js.br: $$(subst $$(space),\$$(space),%).js $$(subst $$(space),\$$(space),%).js.min
	$(info JS Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.js.gz: $$(subst $$(space),\$$(space),%).js $$(subst $$(space),\$$(space),%).js.min
	$(info JS Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.js.min: $$(subst $$(space),\$$(space),%).js
	$(info JS Minifier: $@)
	@terser $(JS_FLAGS) -o "$<.min" -- "$<"




#
# PNG
#
.SECONDEXPANSION:
%.png.br: $$(subst $$(space),\$$(space),%).png $$(subst $$(space),\$$(space),%).png.min
	$(info PNG Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.png.gz: $$(subst $$(space),\$$(space),%).png $$(subst $$(space),\$$(space),%).png.min
	$(info PNG Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.png.min: $$(subst $$(space),\$$(space),%).png
	$(info PNG Minifier: $@)
	@optipng -o7 -clobber -silent -preserve -strip all "$<" -out "$<.min"



#
# JPEG
#
.SECONDEXPANSION:
%.jpeg.br: $$(subst $$(space),\$$(space),%).jpeg $$(subst $$(space),\$$(space),%).jpeg.min
	$(info JPEG Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.jpg.br: $$(subst $$(space),\$$(space),%).jpg $$(subst $$(space),\$$(space),%).jpg.min
	$(info JPEG Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.jpeg.gz: $$(subst $$(space),\$$(space),%).jpeg $$(subst $$(space),\$$(space),%).jpeg.min
	$(info JPEG Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.jpg.gz: $$(subst $$(space),\$$(space),%).jpg $$(subst $$(space),\$$(space),%).jpg.min
	$(info JPEG Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.jpeg.min: $$(subst $$(space),\$$(space),%).jpeg
	$(info JPEG Optimizer: $@)
	@cp "$<" "$<.min"
	@jpegoptim -q -s -m 83 -T 5 "$<.min"

.SECONDEXPANSION:
%.jpg.min: $$(subst $$(space),\$$(space),%).jpg
	$(info JPEG Optimizer: $@)
	@cp "$<" "$<.min"
	@jpegoptim -q -s -m 83 -T 5 "$<.min"




#
# GIF
#
.SECONDEXPANSION:
%.gif.br: $$(subst $$(space),\$$(space),%).gif $$(subst $$(space),\$$(space),%).gif.min
	$(info GIF Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.gif.gz: $$(subst $$(space),\$$(space),%).gif $$(subst $$(space),\$$(space),%).gif.min
	$(info GIF Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.gif.min: $$(subst $$(space),\$$(space),%).gif
	$(info GIF Optimizer: $@)
	@gifsicle -o "$<.min" -O3 --careful --no-comments --no-names --same-delay --same-loopcount --no-warnings -- $<




#
# SVG
#
.SECONDEXPANSION:
%.svg.br: $$(subst $$(space),\$$(space),%).svg $$(subst $$(space),\$$(space),%).svg.min
	$(info SVG Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.svg.gz: $$(subst $$(space),\$$(space),%).svg $$(subst $$(space),\$$(space),%).svg.min
	$(info SVG Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.svg.min: $$(subst $$(space),\$$(space),%).svg
	$(info SVG Optimizer: $@)
	@svgcleaner --copy-on-error --multipass --quiet "$<" "$<.min.svg" 2>/dev/null
	@mv -f "$<.min.svg" "$<.min"



#
# WEBP
#
.SECONDEXPANSION:
%.webp.br: $$(subst $$(space),\$$(space),%).webp $$(subst $$(space),\$$(space),%).webp.min
	$(info WEBP Brotli: $@)
	@brotli --force --best -n -o "$@" "$<.min"

.SECONDEXPANSION:
%.webp.gz: $$(subst $$(space),\$$(space),%).webp $$(subst $$(space),\$$(space),%).webp.min
	$(info WEBP Zopfli: $@)
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"

.SECONDEXPANSION:
%.webp.min: $$(subst $$(space),\$$(space),%).webp
	$(info WEBP Optimizer: $@)
	@cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$<.min"

.SECONDEXPANSION:
%.webp: $$(subst $$(space),\$$(space),%).jpg
	$(info WEBP Converter: $@)
	@cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$@"

.SECONDEXPANSION:
%.webp: $$(subst $$(space),\$$(space),%).png
	$(info WEBP Converter: $@)
	@cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$@"



#
# AV1
#
.SECONDEXPANSION:
%.webm: $$(subst $$(space),\$$(space),%).mkv
	$(info AV1 Encoder: $@)
	@if [[ $$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$<") = "av1" ]] ; then \
		echo Skipping, already AV1 $<; \
	else \
		echo; \
		read -p "Would you like produce a version of $(notdir $<) encoded with AV1? This should produce a smaller file but it will take a while, very roughly a minute per second of video [y/n]: " prompt ; \
		if [ "$$prompt" != "$${prompt#[Yy]}" ] ; then \
			ffmpeg -i "$<" -v error -stats -map 0:0 -c:v libaom-av1 -crf 30 -b:v 2000k -cpu-used 5 -row-mt 1 \
			-enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental -c:a libopus "$@" -b:a 50k; \
		fi; \
	fi

.SECONDEXPANSION:
%.webm: $$(subst $$(space),\$$(space),%).mp4
	$(info AV1 Encoder: $@)
	@if [[ $$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$<") = "av1" ]] ; then \
		echo Skipping, already AV1 $<; \
	else \
		echo; \
		read -p "Would you like produce a version of $(notdir $<) encoded with AV1? This should produce a smaller file but it will take a while, very roughly a minute per second of video [y/n]: " prompt ; \
		if [ "$$prompt" != "$${prompt#[Yy]}" ] ; then \
			ffmpeg -i "$<" -v error -stats -map 0:0 -c:v libaom-av1 -crf 30 -b:v 2000k -cpu-used 5 -row-mt 1 \
			-enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental -c:a libopus "$@" -b:a 50k; \
		fi; \
	fi

.SECONDEXPANSION:
%.av1.webm: $$(subst $$(space),\$$(space),%).webm
	$(info AV1 Encoder: $@)
	@if [[ $$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$<") = "av1" ]] ; then \
		echo Skipping, already AV1 $<; \
	else \
		echo; \
		read -p "Would you like produce a version of $(notdir $<) encoded with AV1? This should produce a smaller file but it will take a while, very roughly a minute per second of video [y/n]: " prompt ; \
		if [ "$$prompt" != "$${prompt#[Yy]}" ] ; then \
			ffmpeg -i "$<" --v error -stats -map 0:0 -c:v libaom-av1 -crf 30 -b:v 2000k -cpu-used 5 -row-mt 1 \
			-enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental -c:a libopus "$@" -b:a 50k; \
		fi; \
	fi


#
# Misc Files
#
.SECONDEXPANSION:
%.br: $$(subst $$(space),\$$(space),%)
	$(info MISC Brotli: $@)
	@brotli --force --best -n -o "$@" "$<"

.SECONDEXPANSION:
%.gz: $$(subst $$(space),\$$(space),%)
	$(info MISC Zopfli: $@)
	@zopfli --i15 "$<" >> "$@"



#resize-images: 	
#	@gm convert "$<" -filter lanczos -resize "2000x2000>" "$<.min" 

	
depend:
	@$(CURRENT_PATH)dependencies.sh



#
# Cleaning
#
clean-webcontent:
	$(info Cleaning Webcontent...)
	@rm -f $(HTML_GZ) $(HTML_BR) $(HTML_MIN) $(CSS_GZ) $(CSS_BR) $(CSS_MIN) $(JS_GZ) $(JS_BR) $(JS_MIN)

clean:
	$(info Cleaning All...)
	@rm -f $(HTML_GZ) $(HTML_BR) $(HTML_MIN) $(CSS_GZ) $(CSS_BR) $(CSS_MIN) $(JS_GZ) $(JS_BR) $(JS_MIN) $(MISC_BR) $(MISC_GZ) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN) $(WEBP_GZ) $(WEBP_BR)  

clean-images:
	$(info Cleaning Images...)
	@rm -f $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP_GZ) $(WEBP_BR) 





#
# Size Listings
#
size: SIZE_GZ = $(shell shopt -s globstar && du -cbs $(SITE_PATH)**/*.gz 2>/dev/null | tail -1 | grep -o '[0-9]*')
size: SIZE_BR = $(shell shopt -s globstar && du -cbs $(SITE_PATH)**/*.br 2>/dev/null | tail -1 | grep -o '[0-9]*')
size: SIZE_NON_COMP = $(shell shopt -s globstar && du -cbs $(SITE_PATH)** --exclude=*.gz --exclude=*.br | tail -1 | grep -o '[0-9]*')
size: 
	$(info Calculating size data...)
	$(info )
	$(info Size of non-compressed files: $(shell echo $$(( $(SIZE_NON_COMP) / 1024 ))) KB)
	@find $(SITE_PATH) -type f ! -name "*.br" ! -name "*.gz" -print0 | \
		du -bax --files0-from=- | \
		sort -k 1 -n -r | \
		head -n 15 | \
		awk 'BEGIN {print "\nTop 15 largest non-compressed files:\nSize (Kbytes) | Filename"} {printf "%-13.1f | %s\n", $$1/(1024), $$2}'

	$(info Size of gzip files: $(shell echo $$(( $(SIZE_GZ) / 1024 ))) KB, $(shell echo $$(( 100 - (($(SIZE_GZ) * 100) / $(SIZE_NON_COMP)) )))% smaller)
	@find $(SITE_PATH) -type f -name "*.gz" -print0 | \
		du -bax --files0-from=- | \
		sort -k 1 -n -r | \
		head -n 15 | \
		awk 'BEGIN {print "\nTop 15 largest gzip files:\nSize (Kbytes) | Filename"} {printf "%-13.1f | %s\n", $$1/(1024), $$2}'

	$(info Size of brotli files: $(shell echo $$(( $(SIZE_BR) / 1024 ))) KB, $(shell echo $$(( 100 - (($(SIZE_BR) * 100) / $(SIZE_NON_COMP)) )))% smaller)
	@find $(SITE_PATH) -type f -name "*.br" -print0 | \
		du -bax --files0-from=- | \
		sort -k 1 -n -r | \
		head -n 15 | \
		awk 'BEGIN {print "\nTop 15 largest brotli files:\nSize (Kbytes) | Filename"} {printf "%-13.1f | %s\n", $$1/(1024), $$2}'
