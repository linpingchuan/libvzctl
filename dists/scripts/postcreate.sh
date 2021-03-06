#!/bin/bash
# Copyright (c) 1999-2017, Parallels International GmbH
#
# This file is part of OpenVZ libraries. OpenVZ is free software; you can
# redistribute it and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
# Our contact details: Parallels International GmbH, Vordergasse 59, 8200
# Schaffhausen, Switzerland.
#
# This script runnning on HN and perform next postinstall tasks:
# 1. Randomizes crontab for given VPS so all crontab tasks
#  of all VEs will not start at the same time.
# 2. Disables root password if it is empty.
#

function randcrontab()
{
	local file=${VE_ROOT}"$1"

	[ -f "${file}" ] || return 0

	/bin/cp -fp ${file} ${file}.$$
	cat ${file} | awk '
BEGIN { srand(); }
{
	if ($0 ~ /^[ \t]*#/ || $0 ~ /^[ \t]+*$/) {
		print $0;
		next;
	}
	if ((n = split($0, ar)) < 7) {
		print $0;
		next;
	}
	# min
	if (ar[1] ~ /^[0-9]+$/) {
		ar[1] = int(rand() * 59);
	} else if (ar[1] ~/^-\*\/[0-9]+$/) {
		r = int(rand() * 40) + 15;
		ar[1] = "-*/" r;
	}
	# hour
	if (ar[2] ~ /^[0-9]+$/) {
		ar[2] = int(rand() * 6);
	}
	# day
	if (ar[3] ~ /^[0-9]+$/) {
		ar[3] = int(rand() * 31) + 1;
	}
	line = ar[1];
	for (i = 2; i <= n; i++) {
		line = line " "  ar[i];
	}
	print line;
}
' > ${file}.$$ && /bin/mv -f ${file}.$$ ${file}
	/bin/rm -f ${file}.$$ 2>/dev/null
}

set_localhost()
{
	local file=${VE_ROOT}"/etc/hosts"

	if ! grep -q '127.0.0.1' ${file} 2>/dev/null; then
		echo '127.0.0.1 localhost.localdomain localhost' >> ${file}
	fi

	file=${VE_ROOT}"/etc/resolv.conf"
	if [ ! -e "${file}" ]; then
		touch ${file}
	fi
}

function disableroot()
{
	local file=${VE_ROOT}"/etc/passwd"

	[ -f "$file" ] || return 0

	if /bin/grep -q "^root::" "${file}" 2>/dev/null; then
		/bin/sed 's/^root::/root:!!:/g' < ${file} > ${file}.$$ && \
			/bin/mv -f ${file}.$$ ${file}
		/bin/rm -f ${file}.$$ 2>/dev/null
	fi
}

function set_screenrc()
{
	local file=${VE_ROOT}"/root/.screenrc"

	if [ -f "$file" ] ; then
		grep -q '^defshell' "$file" && return 0
	fi

	echo "defshell -/bin/bash" >> "$file"
}

umask 0022
randcrontab /etc/crontab
randcrontab /etc/cron.d/dailyjobs
set_localhost
disableroot

[ -f ${VE_ROOT}/etc/debian_version ] && set_screenrc

exit 0
