#pragma warning disable 213
#pragma warning disable 234
#define NO_TAGS
#define MIXED_SPELLINGS
// Look for an upgraded version of this file in common locations.
#tryinclude ".\omp-stdlib\_open_mp"
#tryinclude "..\omp-stdlib\_open_mp"
#tryinclude <omp-stdlib\_open_mp>
#tryinclude ".\omp-stdlib-master\_open_mp"
#tryinclude "..\omp-stdlib-master\_open_mp"
#tryinclude <omp-stdlib-master\_open_mp>
#tryinclude "_open_mp"
#tryinclude <_open_mp>

#if !defined _INC_open_mp
	#error Could not find the latest version of the open.mp includes.
#endif
