#/* vim:set tabstop=4 textwidth=80 shiftwidth=4 cindent cino=(0,ml,\:0:
# * ( settings from: http://goanna.cs.rmit.edu.au/~nml/conventions.html )
# */
#
#/**********************************************************************
#    Vimeo-DL
#    Copyright (C) 2010-2012 DaTaPaX (Todd Harbour t/a)
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License
#    version 2 ONLY, as published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program, in the file COPYING or COPYING.txt; if
#    not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# **********************************************************************/

# Programs
ARCHIVER    = tar -zcvf
ARCHIVE_EXT = tar.gz

APPNAME = Vimeo-DL
BINNAME = vimeo-dl
PROGVER="$$(grep APP_VER $(BINNAME).sh|head -1|cut -d'"' -f2)"
ARCHIVE_NAME="$(BINNAME)-$(PROGVER)"

PROGS = $(BINNAME).sh
DIST_FILES = $(PROGS) COPYING README Changelog Makefile

# Default target
PHONY: err

svnup:
	# Ensure up to date
	svn up

Changelog: svnup
	# Generate Changelog
	@echo "Making Changelog"
	svn log >Changelog


err:
	@echo "No target specified (try dist)"

dist: svnup $(DIST_FILES)
	@echo "Making " $(ARCHIVE_NAME).$(ARCHIVE_EXT)

	@if [ -d "$(ARCHIVE_NAME)" ]; then \
		echo "Directory '$(ARCHIVE_NAME)' exists"; \
		exit 1; \
	fi

	@if [ -f "$(ARCHIVE_NAME).$(ARCHIVE_EXT)" ]; then \
		echo "Archive '$(ARCHIVE_NAME).$(ARCHIVE_EXT)' exists"; \
		exit 2; \
	fi

	@mkdir "$(ARCHIVE_NAME)"
	
	@cp -a $(DIST_FILES) "$(ARCHIVE_NAME)/"
	@$(ARCHIVER) "$(ARCHIVE_NAME).$(ARCHIVE_EXT)" "$(ARCHIVE_NAME)/"

clean:
	@echo "Cleaning up..."
	
	@if [ -d "$(ARCHIVE_NAME)" ]; then \
		echo "  deleting: $(ARCHIVE_NAME)"; \
		rm -Rf "$(ARCHIVE_NAME)"; \
	fi
	
	@echo "Done."

distclean: clean
	@echo "Cleaning (for distribution)..."
	
	@if [ -f "$(ARCHIVE_NAME).$(ARCHIVE_EXT)" ]; then \
		echo "  deleting: $(ARCHIVE_NAME).$(ARCHIVE_EXT)"; \
		rm "$(ARCHIVE_NAME).$(ARCHIVE_EXT)"; \
	fi
	
	@if [ -f "Changelog" ]; then \
		rm "Changelog"; \
	fi
	
	@echo "Done."
