--[[
The original library source: https://github.com/vrld/hump/blob/master/vector.lua

The original library license:

Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining A copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

This fork uses the following fork of the original software:
https://github.com/slime73/hump/blob/master/Vector2.lua , using FFI, by slime73

What THIS fork have done on top of those:
Added, removed, optimized, renamed stuff for Gunigine's requirements, by Shell32 (Leandro Fonseca)
This fork is licensed under MIT license as above.
]]--

Vector2 = {}
local Vector2 = Vector2

Vector2.__index = Vector2

local Cosine, Sine, ArcTangent2 = math.cosine or Math.Cosine, math.sine or Math.Sine, math.atan2 or Math.ArcTangent2
local ToNumber = tonumber or ToNumber 
local Type = type or Type
local SetMetatable = setmetatable or SetMetatable

local FFI = FFI or require("ffi") or Require and Require("ffi")

FFI.cdef("struct Vector2 { float X, Y; };")

do
	local Vec2 = FFI.typeof("struct Vector2")
	
	function Vector2:Zero()
		return Vec2(0, 0)
	end
	
	local function IsVec2(Value)
		return FFI.istype(Vec2, Value)
	end
	
	function Vector2.New(X, Y)
		return Vec2(X, Y)
	end
	
	function Vector2:Copy()
		return Vec2(self.X, self.Y)
	end
	
	function Vector2:Unpack()
		return self.X, self.Y
	end
	
	function Vector2:__tostring()
		return "Vector2(" .. ToNumber(self.X) .. ", " .. ToNumber(self.Y) .. ")"
	end
	
	function Vector2.Set(A, X, Y)
		A.X = X
		A.Y = Y
	end
	
	function Vector2.Unm(A)
		A.X = -A.X
		A.Y = -A.Y
	end
	
	function Vector2.Add(A, X, Y)
		A.X = A.X + X
		A.Y = A.Y + Y
	end
	
	function Vector2.Sub(A, X, Y)
		A.X = A.X - X
		A.Y = A.Y - Y
	end
	
	function Vector2.Mul(A, X, Y)
		if Y == nil then
			if Type(X) == "number" then
				A.X = A.X * X
				A.Y = A.Y * X
			else
				return A.X * X.X + A.Y * X.Y
			end
		else
			A.X = A.X * X
			A.Y = A.Y * Y
		end
	end
	
	function Vector2.Div(A, X)
		A.X = A.X / X
		A.Y = A.Y / Y
	end
	
	function Vector2.Equal(A, X, Y)
		return A.X == X and A.Y == Y
	end
	
	function Vector2.LessThan(A, X, Y)
		return A.X < X or (A.X == X and A.Y < Y)
	end
	
	function Vector2.LessEqual(A, X, Y)
		return A.X <= X and A.Y <= Y
	end
	
	function Vector2.GreaterThan(A, X, Y)
		return not (A.X <= X and A.Y <= Y)
	end
	
	function Vector2.GreaterEqual(A, X, Y)
		return not (A.X < X or (A.X == X and A.Y < Y))
	end
	
	function Vector2.__unm(A)
		return Vec2(-A.X, -A.Y)
	end
	
	function Vector2.__add(A, B)
		return Vec2(A.X + B.X, A.Y + B.Y)
	end
	
	function Vector2.__sub(A, B)
		return Vec2(A.X - B.X, A.Y - B.Y)
	end
	
	function Vector2.__mul(A, B)
		if Type(A) == "number" then
			return Vec2(A * B.X, A * B.Y)
		elseif Type(B) == "number" then
			return Vec2(B * A.X, B * A.Y)
		else
			return A.X * B.X + A.Y * B.Y
		end
	end
	
	function Vector2.__div(A, B)
		return Vec2(A.X / B, A.Y / B)
	end
	
	function Vector2.__eq(A, B)
		if not A or not B then return false end
		return A.X == B.X and A.Y == B.Y
	end
	
	function Vector2.__lt(A, B)
		return A.X < B.X or (A.X == B.X and A.Y < B.Y)
	end
	
	function Vector2.__le(A, B)
		return A.X <= B.X and A.Y <= B.Y
	end
	
	function Vector2.GetPermul(A, B)
		return Vec2(A.X * B.X, A.Y * B.Y)
	end
	
	function Vector2:Permul(A, B)
		self.X, self.Y = A.X * B.X, A.Y * B.Y
	end
	
	function Vector2:Length()
		return (self.X * self.X + self.Y * self.Y) ^ 0.5
	end
	
	function Vector2:Length2()
		return self.X * self.X + self.Y * self.Y
	end
	
	function Vector2.Distance(A, B)
		local Dx = A.X - B.X
		local Dy = A.Y - B.Y
		return (Dx * Dx + Dy * Dy) ^ 0.5
	end
	
	function Vector2.Distance2(A, B)
		local Dx = A.X - B.X
		local Dy = A.Y - B.Y
		return (Dx * Dx + Dy * Dy)
	end
	
	function Vector2:NormalizeInPlace()
		local Length = ((self.X * self.X + self.Y * self.Y) ^ 0.5)
		if Length > 0 then
			self.X, self.Y = self.X / Length, self.Y / Length
		end
		return self
	end
	
	function Vector2:GetNormalize()
		local Normal = Vec2(self.X, self.Y)
		local Length = ((Normal.X * Normal.X + Normal.Y * Normal.Y) ^ 0.5)
		if Length > 0 then
			Normal.X, Normal.Y = Normal.X / Length, Normal.Y / Length
		end
		return Normal
	end
	
	function Vector2:Normalize()
		local Length = ((self.X * self.X + self.Y * self.Y) ^ 0.5)
		if Length > 0 then
			self.X, self.Y = self.X / Length, self.Y / Length
		end
	end
	
	function Vector2:RotateInPlace(pi)
		local Cos, Sine = Cosine(pi), Sine(pi)
		self.X, self.Y = Cos * self.X - Sine * self.Y, Sine * self.X + Cos * self.Y
		return self
	end
	
	function Vector2:GetRotate(pi)
		local Cos, Sine = Cosine(pi), Sine(pi)
		return Vec2(Cos * self.X - Sine * self.Y, Sine * self.X + Cos * self.Y)
	end
	
	function Vector2:Rotate(pi)
		local Cos, Sine = Cosine(pi), Sine(pi)
		self.X, self.Y = Cos * self.X - Sine * self.Y, Sine * self.X + Cos * self.Y
	end
	
	function Vector2:GetPerpendicular()
		return Vec2(-self.Y, self.X)
	end
	
	function Vector2:Perpendicular()
		self.X, self.Y = -self.Y, self.X
	end
	
	function Vector2:GetProjectOn(Value)
		local Sine = (self.X * Value.X + self.Y * Value.Y) / (Value.X * Value.X + Value.Y * Value.Y)
		return Vec2(Sine * Value.X, Sine * Value.Y)
	end
	
	function Vector2:ProjectOn(Value)
		local Sine = (self.X * Value.X + self.Y * Value.Y) / (Value.X * Value.X + Value.Y * Value.Y)
		self.X, self.Y = Sine * Value.X, Sine * Value.Y
	end

	function Vector2:GetMirrorOn(Value)
		local Sine = 2 * (self.X * Value.X + self.Y * Value.Y) / (Value.X * Value.X + Value.Y * Value.Y)
		return Vec2(Sine * Value.X - self.X, Sine * Value.Y - self.Y)
	end
	
	function Vector2:MirrorOn(Value)
		local Sine = 2 * (self.X * Value.X + self.Y * Value.Y) / (Value.X * Value.X + Value.Y * Value.Y)
		self.X, self.Y = Sine * Value.X - self.X, Sine * Value.Y - self.Y
	end

	function Vector2:Cross(Value)
		return self.X * Value.Y - self.Y * Value.X
	end
	
	function Vector2:TrimInPlace(MaxLength)
		local Sine = MaxLength * MaxLength / (self.X * self.X + self.Y * self.Y)
		Sine = (Sine > 1 and 1) or Sine ^ 0.5
		self.X, self.Y = self.X * Sine, self.Y * Sine
		return self
	end
	
	function Vector2:AngleTo(other)
		if other then
			return ArcTangent2(self.Y, self.X) - ArcTangent2(other.Y, other.X)
		end
		
		return ArcTangent2(self.Y, self.X)
	end
	
	function Vector2:GetTrim(MaxLength)
		local Trim = Vec2(self.X, self.Y)
		local Sine = MaxLength * MaxLength / (Trim.X * Trim.X + Trim.Y * Trim.Y)
		Sine = (Sine > 1 and 1) or Sine ^ 0.5
		Trim.X, Trim.Y = Trim.X * Sine, Trim.Y * Sine
		return Trim
	end
	
	function Vector2:Trim(MaxLength)
		local Sine = MaxLength * MaxLength / (self.X * self.X + self.Y * self.Y)
		Sine = (Sine > 1 and 1) or Sine ^ 0.5
		self.X, self.Y = self.X * Sine, self.Y * Sine
	end
	
	function Vector2:IsInSquare(Position, Size)
		if self.X > Position.X and self.Y > Position.Y and self.X < Position.X + Size.X  and self.Y < Position.Y + Size.Y then
			return true
		else
			return false
		end
	end
	
	FFI.metatype(Vec2, Vector2)
	
	_G.Vec2 = SetMetatable({Vec2 = Vec2, IsVec2 = IsVec2}, {__call = function(_, ...) return Vec2(...) end})
end