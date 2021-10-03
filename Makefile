space:= 
space+=
SHELL:=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
NC=\033[0m


ERROR := @if ! 
HANDLER = ; then echo -e "[${RED}ERROR${NC}] $@, copying original file"; cp "$<" "$<.min"; fi
SIZE_CHECK = @if [[ $$(wc -c "$<" "$@" | sort -k 1 -n | head -n 1 | { read first rest ; echo $$rest ; }) != "$@" ]] ; then \
		echo -e "[${GREEN}INFO${NC}] $@, larger than the original, deleting"; \
		rm -f "$@"; \
	fi

CURRENT_PATH := $(subst $(lastword $(notdir $(MAKEFILE_LIST))),,$(subst $(space),\$(space),$(shell realpath '$(strip $(MAKEFILE_LIST))')))
SITE_PATH := $(shell cat $(CURRENT_PATH).site.path 2>/dev/null)

ifeq ($(strip $(SITE_PATH)),)
    userInput := $(shell read -p "Enter directory of web site (can be relative or absolute): " userInput; echo $$userInput)
    $(info Saving site path to $(CURRENT_PATH).site.path)
    SITE_PATH := $(shell realpath $(userInput))
    $(shell echo $(SITE_PATH) >> $(CURRENT_PATH).site.path)
endif

PREPROCESS := $(info $(shell ./preprocess.sh $(SITE_PATH)))


HTML := $(info Finding HTML files...) $(shell find $(SITE_PATH) -type f -name '*.html' | perl -p -e 's/ /\\ /g')
HTML_BR := $(HTML:%.html=%.html.br) 
HTML_GZ := $(HTML:%.html=%.html.gz)
HTML_MIN := $(HTML:%.html=%.html.min)
HTML_FLAGS := --collapse-inline-tag-whitespace \
				--collapse-boolean-attributes \
				--remove-comments \
				--remove-optional-tags \
				--remove-redundant-attributes \
				--remove-script-type-attributes \
				--remove-tag-whitespace \
				--sort-attributes \
				--sort-class-name \
				--minify-css true \
				--minify-js true

CSS := $(info Finding CSS files...) $(shell find $(SITE_PATH) -type f -name '*.css' | perl -p -e 's/ /\\ /g')
CSS_BR := $(CSS:%.css=%.css.br)
CSS_GZ := $(CSS:%.css=%.css.gz)
CSS_MIN := $(CSS:%.css=%.css.min)


JS := $(info Finding JS files...) $(shell find $(SITE_PATH) -type f -name '*.js' | perl -p -e 's/ /\\ /g')
JS_BR := $(JS:%.js=%.js.br)
JS_GZ := $(JS:%.js=%.js.gz)
JS_MIN := $(JS:%.js=%.js.min)
JS_FLAGS := --compress --mangle


PNG := $(info Finding PNG files...) $(shell find $(SITE_PATH) -type f -name '*.png' | perl -p -e 's/ /\\ /g')
PNG_GZ := $(PNG:%.png=%.png.gz)
PNG_BR := $(PNG:%.png=%.png.br)
PNG_MIN := $(PNG:%.png=%.png.min)


JPEG_GZ := $(info Finding JPEG files...) $(shell find $(SITE_PATH) -type f  \( -name '*.jpeg' -o -name '*.jpg' \)  | perl -p -e 's/ /\\ /g; s/\n/.gz\n/')
JPEG_BR := $(JPEG_GZ:%.gz=%.br)
JPEG_MIN := $(JPEG_GZ:%.gz=%.min)


GIF := $(info Finding GIF files...) $(shell find $(SITE_PATH) -type f -name '*.gif' | perl -p -e 's/ /\\ /g')
GIF_GZ := $(GIF:%.gif=%.gif.gz)
GIF_BR := $(GIF:%.gif=%.gif.br)
GIF_MIN := $(GIF:%.gif=%.gif.min)


SVG := $(info Finding SVG files...) $(shell find $(SITE_PATH) -type f -name '*.svg' | perl -p -e 's/ /\\ /g')
SVG_GZ := $(SVG:%.svg=%.svg.gz)
SVG_BR := $(SVG:%.svg=%.svg.br)
SVG_MIN := $(SVG:%.svg=%.svg.min)


WEBP := $(info Finding WEBP files...) $(shell find $(SITE_PATH) -type f \( -name '*.jpeg' -o -name '*.jpg' -o -name "*.png" \)  | perl -p -e 's/ /\\ /g; s/jpeg\n|jpg\n|png\n/webp\n/g')

AV1 := $(info Finding AV1 files...) $(shell find $(SITE_PATH) -type f \( -name '*.mkv' -o -name '*.mp4' -o -name '*.webm' \)  | perl -p -e 's/ /\\ /g; s/webm\n/av1.webm\n/g; s/mkv\n|mp4\n/webm\n/g')

AVIF := $(info Finding AVIF files...) $(shell find $(SITE_PATH) -type f \( -name '*.jpeg' -o -name '*.jpg' -o -name "*.png" \)  | perl -p -e 's/ /\\ /g; s/jpeg\n|jpg\n|png\n/avif\n/g')


MISC_TYPES := -name '*.txt' \
                -o -name '*.xml' \
                -o -name '*.csv' \
                -o -name '*.json' \
                -o -name '*.bmp' \
                -o -name '*.otf' \
                -o -name '*.ttf' \
                -o -name '*.webmanifest'

MISC_BR := $(info Finding miscellaneous files...) $(shell find $(SITE_PATH) -type f \( $(MISC_TYPES) \) | perl -p -e 's/ /\\ /g; s/\n/.br\n/')
MISC_GZ := $(MISC_BR:%.br=%.gz)






.INTERMEDIATE: $(HTML_MIN) $(CSS_MIN) $(JS_MIN) $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN)
.PHONY: all size depend clean clean-webcontent clean-images misc webcontent html experimental js css images png jpeg gif svg webp av1 avif
#.SILENT:


webcontent: $(HTML_GZ) $(HTML_BR) $(CSS_BR) $(CSS_GZ) $(JS_BR) $(JS_GZ)
html: $(HTML_GZ) $(HTML_BR)
js: $(JS_BR) $(JS_GZ)
css: $(CSS_BR) $(CSS_GZ)

images: $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP)
png: $(PNG_GZ) $(PNG_BR)
jpeg: $(JPEG_GZ) $(JPEG_BR)
gif: $(GIF_GZ) $(GIF_BR)
svg: $(SVG_GZ) $(SVG_BR)
webp: $(WEBP)
avif: $(AVIF)
av1: $(AV1)

misc: $(MISC_BR) $(MISC_GZ)
experimental: $(AVIF) $(AV1)
all: $(HTML_GZ) $(HTML_BR) $(CSS_BR) $(CSS_GZ) $(JS_BR) $(JS_GZ) $(MISC_BR) $(MISC_GZ) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP)



#
# HTML
#
.SECONDEXPANSION:
%.html.br: $$(subst $$(space),\$$(space),%).html $$(subst $$(space),\$$(space),%).html.min
	$(info HTML Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.html.gz: $$(subst $$(space),\$$(space),%).html $$(subst $$(space),\$$(space),%).html.min
	$(info HTML Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.html.min: $$(subst $$(space),\$$(space),%).html
	$(info HTML Minifier: $(notdir $@))
	$(ERROR) html-minifier-terser $(HTML_FLAGS) "$<" -o "$<.min" $(HANDLER)


#
# CSS
#
.SECONDEXPANSION:
%.css.br: $$(subst $$(space),\$$(space),%).css $$(subst $$(space),\$$(space),%).css.min
	$(info CSS Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.css.gz: $$(subst $$(space),\$$(space),%).css $$(subst $$(space),\$$(space),%).css.min
	$(info CSS Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.css.min: $$(subst $$(space),\$$(space),%).css
	$(info CSS Minifier: $(notdir $@))
	$(ERROR) cleancss -O2 -o "$<.min" "$<" $(HANDLER)



#
# JavaScript
#
.SECONDEXPANSION:
%.js.br: $$(subst $$(space),\$$(space),%).js $$(subst $$(space),\$$(space),%).js.min
	$(info JS Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.js.gz: $$(subst $$(space),\$$(space),%).js $$(subst $$(space),\$$(space),%).js.min
	$(info JS Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.js.min: $$(subst $$(space),\$$(space),%).js
	$(info JS Minifier: $(notdir $@))
	$(ERROR) terser $(JS_FLAGS) -o "$<.min" -- "$<" $(HANDLER)




#
# PNG
#
.SECONDEXPANSION:
%.png.br: $$(subst $$(space),\$$(space),%).png $$(subst $$(space),\$$(space),%).png.min
	$(info PNG Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.png.gz: $$(subst $$(space),\$$(space),%).png $$(subst $$(space),\$$(space),%).png.min
	$(info PNG Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.png.min: $$(subst $$(space),\$$(space),%).png
	$(info PNG Minifier: $(notdir $@))
	$(ERROR) optipng -o7 -clobber -silent -preserve -strip all "$<" -out "$<.min" $(HANDLER)



#
# JPEG
#
.SECONDEXPANSION:
%.jpeg.br: $$(subst $$(space),\$$(space),%).jpeg $$(subst $$(space),\$$(space),%).jpeg.min
	$(info JPEG Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.jpg.br: $$(subst $$(space),\$$(space),%).jpg $$(subst $$(space),\$$(space),%).jpg.min
	$(info JPEG Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.jpeg.gz: $$(subst $$(space),\$$(space),%).jpeg $$(subst $$(space),\$$(space),%).jpeg.min
	$(info JPEG Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.jpg.gz: $$(subst $$(space),\$$(space),%).jpg $$(subst $$(space),\$$(space),%).jpg.min
	$(info JPEG Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.jpeg.min: $$(subst $$(space),\$$(space),%).jpeg
	$(info JPEG Optimizer: $(notdir $@))
	@cp "$<" "$<.min"
	$(ERROR) jpegoptim -q -s -m 83 -T 5 "$<.min" $(HANDLER)

.SECONDEXPANSION:
%.jpg.min: $$(subst $$(space),\$$(space),%).jpg
	$(info JPEG Optimizer: $(notdir $@))
	@cp "$<" "$<.min"
	$(ERROR) jpegoptim -q -s -m 83 -T 5 "$<.min" $(HANDLER)




#
# GIF
#
.SECONDEXPANSION:
%.gif.br: $$(subst $$(space),\$$(space),%).gif $$(subst $$(space),\$$(space),%).gif.min
	$(info GIF Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.gif.gz: $$(subst $$(space),\$$(space),%).gif $$(subst $$(space),\$$(space),%).gif.min
	$(info GIF Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.gif.min: $$(subst $$(space),\$$(space),%).gif
	$(info GIF Optimizer: $(notdir $@))
	$(ERROR) gifsicle -o "$<.min" -O3 --color-method=blend-diversity --lossy=20 --careful --no-comments --no-names --same-delay --same-loopcount --no-warnings -- "$<" $(HANDLER)




#
# SVG
#
.SECONDEXPANSION:
%.svg.br: $$(subst $$(space),\$$(space),%).svg $$(subst $$(space),\$$(space),%).svg.min
	$(info SVG Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<.min"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.svg.gz: $$(subst $$(space),\$$(space),%).svg $$(subst $$(space),\$$(space),%).svg.min
	$(info SVG Zopfli: $(notdir $@))
	@zopfli --i15 "$<.min"
	@mv -f "$<.min.gz" "$@"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.svg.min: $$(subst $$(space),\$$(space),%).svg
	$(info SVG Optimizer: $(notdir $@))
	$(ERROR) svgcleaner --copy-on-error --multipass --quiet "$<" "$<.min.svg" 2>/dev/null $(HANDLER)
	@mv -f "$<.min.svg" "$<.min"




#
# WEBP
#
.SECONDEXPANSION:
%.webp: $$(subst $$(space),\$$(space),%).jpg
	$(info WEBP Encoder: $(notdir $@))
	$(ERROR) cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$@" $(HANDLER)

.SECONDEXPANSION:
%.webp: $$(subst $$(space),\$$(space),%).jpeg
	$(info WEBP Encoder: $(notdir $@))
	$(ERROR) cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$@" $(HANDLER)

.SECONDEXPANSION:
%.webp: $$(subst $$(space),\$$(space),%).png
	$(info WEBP Encoder: $(notdir $@))
	$(ERROR) cwebp -q 83 -alpha_q 83 -pass 10 -m 6 -sharp_yuv -quiet "$<" -o "$@" $(HANDLER)




#
# AVIF
#
.SECONDEXPANSION:
%.avif: $$(subst $$(space),\$$(space),%).ivf
	$(info AVIF Muxer: $(notdir $@))
	$(ERROR) MP4Box -add-image "$<":time=0 -brand avif "$@" $(HANDLER)

.SECONDEXPANSION:
%.ivf: $$(subst $$(space),\$$(space),%).jpg
	$(info IVF Encoder: $(notdir $@))
	$(ERROR) ffmpeg -v quiet -r 1 -i "$<" -g 1 -frames 1 -map 0:0 -c:v libaom-av1 -crf 45 -b:v 0 -cpu-used 4 -row-mt 1 -enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental "$@" $(HANDLER)

.SECONDEXPANSION:
%.ivf: $$(subst $$(space),\$$(space),%).jpeg
	$(info IVF Encoder: $(notdir $@))
	$(ERROR) ffmpeg -v quiet -r 1 -i "$<" -g 1 -frames 1 -map 0:0 -c:v libaom-av1 -crf 45 -b:v 0 -cpu-used 4 -row-mt 1 -enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental "$@" $(HANDLER)

.SECONDEXPANSION:
%.ivf: $$(subst $$(space),\$$(space),%).png
	$(info IVF Encoder: $(notdir $@))
	$(ERROR) ffmpeg -v quiet -r 1 -i "$<" -g 1 -frames 1 -map 0:0 -c:v libaom-av1 -crf 45 -b:v 0 -cpu-used 4 -row-mt 1 -enable-cdef 1 -enable-global-motion 1 -enable-intrabc 1 -frame-parallel 0 -strict experimental "$@" $(HANDLER)




#
# AV1
#
.SECONDEXPANSION:
%.webm: $$(subst $$(space),\$$(space),%).mkv
	$(info AV1 Encoder: $(notdir $@))
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
	$(info AV1 Encoder: $(notdir $@))
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
	$(info AV1 Encoder: $(notdir $@))
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
	$(info MISC Brotli: $(notdir $@))
	@brotli --force --best -n -o "$@" "$<"
	$(SIZE_CHECK)

.SECONDEXPANSION:
%.gz: $$(subst $$(space),\$$(space),%)
	$(info MISC Zopfli: $(notdir $@))
	@zopfli --i15 "$<" >> "$@"
	$(SIZE_CHECK)



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
	@rm -f $(HTML_GZ) $(HTML_BR) $(HTML_MIN) $(CSS_GZ) $(CSS_BR) $(CSS_MIN) $(JS_GZ) $(JS_BR) $(JS_MIN) $(MISC_BR) $(MISC_GZ) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN) $(WEBP) $(AVIF) $(AV1)

clean-images:
	$(info Cleaning Images...)
	@rm -f $(PNG_MIN) $(JPEG_MIN) $(GIF_MIN) $(SVG_MIN) $(PNG_GZ) $(PNG_BR) $(JPEG_GZ) $(JPEG_BR) $(GIF_GZ) $(GIF_BR) $(SVG_GZ) $(SVG_BR) $(WEBP) $(AVIF)





#
# Size Listings
#
size: SIZE_GZ = $(shell shopt -s globstar && cd $(SITE_PATH) && du -cbs **/*.gz 2>/dev/null | tail -1 | grep -o '[0-9]*')
size: SIZE_BR = $(shell shopt -s globstar && cd $(SITE_PATH) && du -cbs **/*.br 2>/dev/null | tail -1 | grep -o '[0-9]*')
size: SIZE_NON_COMP = $(shell shopt -s globstar && cd $(SITE_PATH) && du -cbs ** --exclude=*.gz --exclude=*.br | tail -1 | grep -o '[0-9]*')
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
