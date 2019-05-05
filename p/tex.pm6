unit module tex;

use SDL2::Raw;

class Tex is export {
	has SDL_Texture $.tex;
	has $.w;
	has $.h;
	has $.framebuffer is rw;
}
