################################################################################
# Sample configuration settings for makefile for generating EPUB 3 ebooks      #
# from content sources.                                                        #
# Copyright (C) 2016  Mark A. Gibbs                                            #
#                                                                              #
# This program is free software: you can redistribute it and/or modify         #
# it under the terms of the GNU General Public License as published by         #
# the Free Software Foundation, either version 3 of the License, or            #
# (at your option) any later version.                                          #
#                                                                              #
# This program is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                #
# GNU General Public License for more details.                                 #
#                                                                              #
# You should have received a copy of the GNU General Public License            #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.        #
#                                                                              #
################################################################################

################################################################################
# Quick guide:                                                                 #
#                                                                              #
# The only settings you really need to define are:                             #
#  * book:    Set this to the name of the EPUB file you want to create         #
#             (without the EPUB extension)                                     #
#  * srcdir:  Set this to the directory that your content documents are laid   #
#             out in (if it's called "build", you will also have to define     #
#             builddir to something (other than "build"))                      #
#  * opf:     Set this to the package document(s) (the .opf file(s)) for the   #
#             book (relative to srcdir)                                        #
#  * content: Set this to all the content documents (relative to srcdir)       #
#                                                                              #
# For more options and information check the README at:                        #
#   https://github.com/DarkerStar/epub-build-makefile                          #
#                                                                              #
################################################################################

# book (required) ##############################################################
# This should be set to the name of the EPUB you want to generate, WITHOUT the
# .epub extension or any path. If you want to control the location of where the
# final book goes, use the outdir variable.
book := book-title

# srcdir (required) ############################################################
# This is the directory that your book is laid out in. Except where stated
# otherwise, all other files and paths are relative to this directory.
srcdir := src

# outdir (optional) ############################################################
# This is the directory that your book will be in after building, along with any
# cover images you request. It should not be the same as either srcdir or 
# builddir. By default it will be the directory of the makefile.
# 
# Default: . (makefile directory)
outdir := .

# builddir (optional) ##########################################################
# This is the directory that your book will be laid out in during the build
# process. It should not be the same as srcdir or outdir or any existing
# directory.
# 
# Default: build
# 
# WARNING: this entire directory is deleted during clean-up. DO NOT USE an
#          existing directory, or any other directory you might want to keep.
builddir := build

# opf (required) ###############################################################
# This is the package document (the .opf file) for your book. The EPUB spec
# allows you to have more than one, so you can have multiple books in a single
# EPUB package.
opf := content.opf

# content (required) ###########################################################
# This is a list of all content files you want in the book (not including the
# package document or the files in META-INF). Those that don't exist will be
# generated, if possible. All paths for existing documents must be relative to
# srcdir, and the paths will be the same as in the final book (so you have to
# lay things out in srcdir the way they will be laid out in the book).
# 
# Other than the package document(s), the META-INF directory and its contents,
# and the mimetype file, everything that is going into the EPUB must be listed
# here.
content := toc.xhtml \
           text/cover.xhtml \
           text/title-page.xhtml \
           text/chapter-01.xhtml \
           text/chapter-02.xhtml \
           text/chapter-03.xhtml \
           style/style.css \
           img/cover.svg \
           img/cover.png \
           toc.ncx

# metafiles (optional) #########################################################
# This is the list of package meta files - files that are in the META-INF
# directory. All paths are relative to META-INF. Don't specify the required
# container.xml file unless you wish to use a custom one rather than the
# automatically generated one.
# 
# This is only really useful if you are using encryption or DRM, in which case
# you might set it like:
#   metafiles := encryption.xml rights.xml
# 
# If your custom metalfiles are not in srcdir, you can use metafilesdir to
# specify where they are.
# 
# Default: (empty)
metafiles := 

# metafilesdir (optional) ######################################################
# The directory, relative to srcdir, where the custom metafiles can be found.
# 
# Default: (empty)
metafilesdir := 

# builddir (optional) ##########################################################
# This is the directory that your book will be laid out in during the build
# process. It should not be the same as srcdir or any existing directory.
# 
# Default: build
# 
# WARNING: this entire directory is deleted during clean-up. DO NOT USE an
#          existing directory, or any other directory you might want to keep.
builddir := build

# epubcheck (optional) #########################################################
# The path to the epubcheck jarfile. This is not necessary unless you want to
# use "make check" to check the epub.
# 
# By default it uses an environment variable - EPUBCHECK_JAR - to determine the
# value.
# 
# Default: $(EPUBCHECK_JAR)
epubcheck := $(EPUBCHECK_JAR)
