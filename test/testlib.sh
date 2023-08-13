########################################################################
#                                                                      #
# This file is part of Indi's EPUB Makefile project.                   #
#                                                                      #
# Indi's EPUB Makefile project is free software: you can               #
# redistribute it and/or modify it under the terms of the              #
# GNU General Public License as published by the                       #
# Free Software Foundation, either version 3 of the License,           #
# or (at your option) any later version.                               #
#                                                                      #
# Indi's EPUB Makefile project is distributed in the hope that         #
# it will be useful, but WITHOUT ANY WARRANTY; without even            #
# the implied warranty of MERCHANTABILITY or                           #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License #
# for more details.                                                    #
#                                                                      #
# You should have received a copy of the GNU General Public License    #
# along with Indi's EPUB Makefile project.                             #
# If not, see <https://www.gnu.org/licenses/>.                         #
#                                                                      #
########################################################################


# Colourizing support ##################################################

__TEST_fmt_reset=

__TEST_fmt_bold=

__TEST_fmt_fg_cyan=
__TEST_fmt_fg_green=
__TEST_fmt_fg_red=

if [ -t 1 ]
then
	__TEST_fmt_colors=$(tput colors)

	if [ -n "${__TEST_fmt_colors}" ] && [ "${__TEST_fmt_colors}" -ge 8 ]
	then
		__TEST_fmt_reset=$(tput sgr0)

		__TEST_fmt_bold=$(tput bold)

		__TEST_fmt_fg_cyan=$(tput setaf 6)
		__TEST_fmt_fg_green=$(tput setaf 2)
		__TEST_fmt_fg_red=$(tput setaf 1)
	fi
fi


# Check functions ######################################################

__TEST_check()
{
	printf "${__TEST_fmt_bold}${__TEST_fmt_fg_cyan}[CHECK]:${__TEST_fmt_reset} ${__TEST_fmt_bold}%s${__TEST_fmt_reset}\n" "${*}"

	if "${@}"
	then
		printf "${__TEST_fmt_bold}${__TEST_fmt_fg_green}[ PASS]:${__TEST_fmt_reset} ${__TEST_fmt_bold}%s${__TEST_fmt_reset}\n" "${*}"
		return 0
	else
		printf "${__TEST_fmt_bold}${__TEST_fmt_fg_red}[ FAIL]:${__TEST_fmt_reset} ${__TEST_fmt_bold}%s${__TEST_fmt_reset}\n" "${*}"
		return 1
	fi
}


check()
{
	if __TEST_check "${@}"
	then
		:
	else
		:
	fi
}


require()
{
	if __TEST_check "${@}"
	then
		:
	else
		exit 1
	fi
}


__TEST_check_not()
{
	printf "${__TEST_fmt_bold}${__TEST_fmt_fg_cyan}[CHECK]:${__TEST_fmt_reset} ${__TEST_fmt_bold}! %s${__TEST_fmt_reset}\n" "${*}"

	if ! "${@}"
	then
		printf "${__TEST_fmt_bold}${__TEST_fmt_fg_green}[ PASS]:${__TEST_fmt_reset} ${__TEST_fmt_bold}! %s${__TEST_fmt_reset}\n" "${*}"
		return 0
	else
		printf "${__TEST_fmt_bold}${__TEST_fmt_fg_red}[ FAIL]:${__TEST_fmt_reset} ${__TEST_fmt_bold}! %s${__TEST_fmt_reset}\n" "${*}"
		return 1
	fi
}


check_not()
{
	if __TEST_check_not "${@}"
	then
		:
	else
		:
	fi
}


require_not()
{
	if __TEST_check_not "${@}"
	then
		:
	else
		exit 1
	fi
}


# Epubcheck support ####################################################

# If EPUB_MAKEFILE_EPUBCHECK is unset or set to true...
if [ "x${EPUB_MAKEFILE_EPUBCHECK+y}" = 'x' ] || [ "${EPUB_MAKEFILE_EPUBCHECK}" = 'true' ]
then
	epubcheck()
	{
		__TEST_epubcheck_version=${1}
		shift

		if [ ! -d ../epubcheck-${__TEST_epubcheck_version} ]
		then
			if [ ! -f ../epubcheck-${__TEST_epubcheck_version}.zip ]
			then
				( cd .. && wget -q https://github.com/w3c/epubcheck/releases/download/v${__TEST_epubcheck_version}/epubcheck-${__TEST_epubcheck_version}.zip )
			fi

			( cd .. && unzip epubcheck-${__TEST_epubcheck_version}.zip )
		fi

		java -jar ../epubcheck-${__TEST_epubcheck_version}/epubcheck.jar "${@}"
	}
# If EPUB_MAKEFILE_EPUBCHECK is set to null or false...
elif [ "x${EPUB_MAKEFILE_EPUBCHECK-y}" = 'x' ] || [ "${EPUB_MAKEFILE_EPUBCHECK}" = 'false' ]
then
	epubcheck()
	{
		:
	}
# If EPUB_MAKEFILE_EPUBCHECK is a jarfile...
elif [ -f "${EPUB_MAKEFILE_EPUBCHECK}" ] && [  ]
then
	epubcheck()
	{
		shift
		java -jar "${EPUB_MAKEFILE_EPUBCHECK}" "${@}"
	}
# Not unset or true, not null or false, not a jarfile, assume a command...
else
	epubcheck()
	{
		shift
		"${EPUB_MAKEFILE_EPUBCHECK}" "${@}"
	}
fi
