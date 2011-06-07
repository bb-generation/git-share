# Copyright (c) 2011 Bernhard Eder (<git@bbgen.net>)
# Copyright (c) 2010 Vincent Driessen
# 
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
# 
#    1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 
#    2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 
#    3. This notice may not be removed or altered from any source
#    distribution.

# Determine if we're inside a debian build ..
ifdef DEB_BUILD_ARCH
   prefix=$(DESTDIR)/usr/
else
   prefix=/usr/local
endif

EXEC_FILE=git-share

.PHONY: install uninstall

all:
	@echo "usage: make install"
	@echo "       make uninstall"

install:
	install -d -m 0755 $(prefix)/bin
	install -m 0755 $(EXEC_FILE) $(prefix)/bin

uninstall:
	test -d $(prefix)/bin && \
	rm -f $(prefix)/bin/$(EXEC_FILE)

