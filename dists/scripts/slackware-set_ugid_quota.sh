#!/bin/bash
# Copyright (C) 1999-2015 Parallels IP Holdings GmbH
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
# Our contact details: Parallels IP Holdings GmbH, Vordergasse 59, 8200
# Schaffhausen, Switzerland.
#
# This script configures quota startup script inside VPS
#
# Parameters are passed in environment variables.
# Required parameters:
#   MINOR	- root device minor number
#   MAJOR	- root device major number
SCRIPTNAME=/etc/rc.d/rc.quota
RC_LOCAL=/etc/rc.d/rc.local

setup_vzquota()
{
	setup_vzquota_common

	if ! grep -q "${SCRIPTNAME}" ${RC_LOCAL} 2>/dev/null; then
		echo "${SCRIPTNAME} start" >> /etc/rc.d/rc.local
	fi
}

if grep -q '/dev/ploop' /proc/mounts; then
	setup_quota
else
	setup_vzquota
fi

exit 0

