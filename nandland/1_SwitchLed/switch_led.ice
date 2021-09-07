{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "go-board",
    "graph": {
      "blocks": [
        {
          "id": "b06d4a42-d17b-48f4-9c50-1d5f8e798631",
          "type": "basic.output",
          "data": {
            "name": "O1",
            "pins": [
              {
                "index": "0",
                "name": "LED1",
                "value": "56"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 728,
            "y": 112
          }
        },
        {
          "id": "5a13c58e-f1a4-45ea-a460-ca02ae28e032",
          "type": "basic.input",
          "data": {
            "name": "i1",
            "pins": [
              {
                "index": "0",
                "name": "SW1",
                "value": "53"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 104,
            "y": 128
          }
        },
        {
          "id": "84d2bb77-4e50-4242-af57-02252ab06e69",
          "type": "basic.output",
          "data": {
            "name": "O2",
            "pins": [
              {
                "index": "0",
                "name": "LED2",
                "value": "57"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 728,
            "y": 192
          }
        },
        {
          "id": "f344d350-adc7-4a91-81d6-3816d16a5288",
          "type": "basic.input",
          "data": {
            "name": "i2",
            "pins": [
              {
                "index": "0",
                "name": "SW2",
                "value": "51"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 104,
            "y": 208
          }
        },
        {
          "id": "2e499894-cc02-4b01-bc36-f99592fdec2d",
          "type": "basic.output",
          "data": {
            "name": "O3",
            "pins": [
              {
                "index": "0",
                "name": "LED3",
                "value": "59"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 736,
            "y": 264
          }
        },
        {
          "id": "f3bc1f48-194e-4a23-a885-5bfd73b433a0",
          "type": "basic.input",
          "data": {
            "name": "i3",
            "pins": [
              {
                "index": "0",
                "name": "SW3",
                "value": "54"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 104,
            "y": 288
          }
        },
        {
          "id": "c16b3b5c-63a1-4606-a75e-62c75dc124df",
          "type": "basic.input",
          "data": {
            "name": "i4",
            "pins": [
              {
                "index": "0",
                "name": "SW4",
                "value": "52"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 104,
            "y": 368
          }
        },
        {
          "id": "daf4535f-0296-48c7-9f4e-082bc238a960",
          "type": "basic.output",
          "data": {
            "name": "O4",
            "pins": [
              {
                "index": "0",
                "name": "LED4",
                "value": "60"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 728,
            "y": 376
          }
        },
        {
          "id": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
          "type": "basic.code",
          "data": {
            "code": "assign o_LED1 = i_SW1;\nassign o_LED2 = i_SW2;\nassign o_LED3 = i_SW3;\nassign o_LED4 = i_SW4;\n",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "i_SW1"
                },
                {
                  "name": "i_SW2"
                },
                {
                  "name": "i_SW3"
                },
                {
                  "name": "i_SW4"
                }
              ],
              "out": [
                {
                  "name": "o_LED1"
                },
                {
                  "name": "o_LED2"
                },
                {
                  "name": "o_LED3"
                },
                {
                  "name": "o_LED4"
                }
              ]
            }
          },
          "position": {
            "x": 392,
            "y": 184
          },
          "size": {
            "width": 192,
            "height": 128
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "5a13c58e-f1a4-45ea-a460-ca02ae28e032",
            "port": "out"
          },
          "target": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "i_SW1"
          }
        },
        {
          "source": {
            "block": "f344d350-adc7-4a91-81d6-3816d16a5288",
            "port": "out"
          },
          "target": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "i_SW2"
          }
        },
        {
          "source": {
            "block": "f3bc1f48-194e-4a23-a885-5bfd73b433a0",
            "port": "out"
          },
          "target": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "i_SW3"
          }
        },
        {
          "source": {
            "block": "c16b3b5c-63a1-4606-a75e-62c75dc124df",
            "port": "out"
          },
          "target": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "i_SW4"
          }
        },
        {
          "source": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "o_LED1"
          },
          "target": {
            "block": "b06d4a42-d17b-48f4-9c50-1d5f8e798631",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "o_LED2"
          },
          "target": {
            "block": "84d2bb77-4e50-4242-af57-02252ab06e69",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "o_LED3"
          },
          "target": {
            "block": "2e499894-cc02-4b01-bc36-f99592fdec2d",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "622169bd-4e6f-4d0d-87e8-89f4cdcda662",
            "port": "o_LED4"
          },
          "target": {
            "block": "daf4535f-0296-48c7-9f4e-082bc238a960",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}