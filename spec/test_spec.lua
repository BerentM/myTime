package.path = package.path .. ";../myTime/*.lua"
local myTime = require("myTime")
local utils = require("myTime.utils")
require("busted")

describe("hello tests", function()
    describe("first tests", function()
        it("hello world", function()
            assert.are.equal(
                "Hello, World!",
                myTime:first()
            )
        end)
        it("hello name", function()
            assert.are.equal(
                "Hello, Kiniulka!",
                myTime:name("Kiniulka")
            )
        end)
    end)
    describe("utils tests", function()
        it("string split", function()
            local tab = { "a", "b", "c" }

            local out = utils:splitString("a,b,c", ",")
            assert.are.equal(#out, #tab)
            assert.are.same(tab, out)

            out = utils:splitString("a,b,c", ";")
            assert.are.equal(#out, 1)

            out = utils:splitString("a;b;c", ";")
            assert.are.same(tab, out)
        end)
        it("read csv file", function()
            local row1 = { "a", "b", "c" }
            local row2 = { 1, 2, 3 }
            local out = utils:readCsv("spec/test_file.csv", ",")
            assert.are.equal(#out, 2)
            assert.are.same(row1, out[1])
            assert.are.same(row2, out[2])
        end)
        it("generate output rows", function()
            local input = { 1, 2, 3 }
            local out = utils:createLine(input, ";")
            assert.are.equal("1;2;3\n", out)
            input = { "a", "B", "c" }
            out = utils:createLine(input, ",")
            assert.are.equal("a,B,c\n", out)
        end)
        it("save new rows", function()
            local input = { 1, 2, 3 }
            local filePath = "spec/test_file.csv"
            local f1 = #utils:readCsv(filePath, ",") + 1
            utils:appendCsv(filePath, input, ",")
            local f2 = #utils:readCsv(filePath, ",")
            assert.are.equal(f1, f2)

            utils:removeLastRowCsv(filePath)
        end)
        it("create new file", function()
            local input = { 1, 2, 3 }
            local path = "spec/temp.csv"
            utils:appendCsv(path, input, ";")
            os.remove(path)
        end)
    end)
end)
