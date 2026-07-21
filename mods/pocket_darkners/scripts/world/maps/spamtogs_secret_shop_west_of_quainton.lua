return {
  version = "1.11",
  luaversion = "5.1",
  tiledversion = "1.12.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 12,
  tilewidth = 40,
  tileheight = 40,
  nextlayerid = 5,
  nextobjectid = 10,
  backgroundcolor = { 171, 171, 171 },
  properties = {},
  tilesets = {
    {
      name = "quainton_ruins_and_river",
      firstgid = 1,
      filename = "../tilesets/quainton_ruins_and_river.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 12,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 22, 23, 23, 24, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 42, 43, 43, 44, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 62, 26, 25, 64, 123, 123, 123, 123, 123, 123,
        123, 123, 123, 123, 123, 123, 123, 42, 44, 123, 123, 123, 123, 123, 123, 123
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 2,
      name = "collision",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "",
          shape = "rectangle",
          x = 200,
          y = 120,
          width = 40,
          height = 360,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 2,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 80,
          width = 160,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "",
          type = "",
          shape = "rectangle",
          x = 400,
          y = 120,
          width = 40,
          height = 360,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        },
        {
          id = 9,
          name = "",
          type = "",
          shape = "rectangle",
          x = 360,
          y = 440,
          width = 40,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 7,
          name = "transition",
          type = "",
          shape = "rectangle",
          x = 240,
          y = 480,
          width = 160,
          height = 40,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {
            ["facing"] = "down",
            ["map"] = "the_riverbed_west_of_quainton",
            ["marker"] = "secret_exit"
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 4,
      name = "markers",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 5,
          name = "entrance",
          type = "",
          shape = "point",
          x = 320,
          y = 440,
          width = 0,
          height = 0,
          rotation = 0,
          opacity = 1,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
