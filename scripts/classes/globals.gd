extends Node2D

# General
var player : Node

# Globals for building
var hover_target

# Globals for people
enum POI_TYPE {
	CITIZEN,
	ENGINEER,
	OFFICER
}
var idle_pois : Array[Node2D] # Pois that people may wander to
