extends Node2D

# General
var player : Node
var mouse : Area2D
var ability_holder : Node
var victory_control : Control
var defeat_control : Control

# Globals for building
var hover_target

# Globals for people
enum POI_TYPE {
	CITIZEN,
	ENGINEER,
	OFFICER
}
var idle_pois : Array[Node2D] # Pois that people may wander to
var other_people : Array[Node2D]
