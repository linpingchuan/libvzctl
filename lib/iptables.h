/*
 *  Copyright (c) 1999-2015 Parallels IP Holdings GmbH
 *
 * This file is part of OpenVZ libraries. OpenVZ is free software; you can
 * redistribute it and/or modify it under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation; either version
 * 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.  If not, see
 * <http://www.gnu.org/licenses/> or write to Free Software Foundation,
 * 51 Franklin Street, Fifth Floor Boston, MA 02110, USA.
 *
 * Our contact details: Parallels IP Holdings GmbH, Vordergasse 59, 8200
 * Schaffhausen, Switzerland.
 *
 */
#ifndef	_VZCTL_IPTABLES_H_
#define _VZCTL_IPTABLES_H_

struct vzctl_features_param;

int parse_iptables(unsigned long *mask, const char *val);
void iptables_mask2str(unsigned long mask, char *buf, int size);
int parse_netfilter(unsigned long *mask, const char *val);
void netfilter_mask2str(unsigned long mask, char *buf, int size);
unsigned long long get_ipt_mask(struct vzctl_features_param *param);

#endif //_IPTABLES_H_
