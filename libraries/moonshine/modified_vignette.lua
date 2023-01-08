--[[
Public domain:

Copyright (C) 2017 by Matthias Richter <vrld@vrld.org>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
]]--

return function(moonshine)
    local shader = love.graphics.newShader[[
      number realX;
      number realY;
      extern number radius;
      extern number opacity;
      
      extern vec2 position;
    
      vec4 effect(vec4 c, Image tex, vec2 tc, vec2 _)
      {
        vec2 realC = vec2(tc.x * 1200.0, tc.y * 800.0);
        vec4 texcolor = Texel(tex, tc);
        if (distance(realC, position) <= radius){
            return texcolor * c;
        }else{
            return texcolor * vec4(1, 1, 1, opacity);
        }
      }]]
  
    local setters = {}
    for _,k in ipairs{"radius", "opacity"} do
      setters[k] = function(v) shader:send(k, math.max(0, tonumber(v) or 0)) end
    end
    setters.position = function (p)
        assert(type(p) == "table" and #p == 2, "invalid parameter")
        shader:send("position", {
            p[1], p[2]
        })
    end
  
    return moonshine.Effect{
      name = "modified_vignette",
      shader = shader,
      setters = setters,
      defaults = {
        radius = .8,
        opacity = 1,
        position = {0.5, 0.5}
      }
    }
  end
  