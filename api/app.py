from flask import Flask, render_template, request, redirect, url_for, g, flash, abort, jsonify, send_file, Response, make_response
import requests
import base64
import hashlib
import time
import socket
import threading
import random
import string
import os
import re

app = Flask(__name__)
app.config['SECRET_KEY'] = "Hikari"

@app.route('/', methods=["GET"])
def home():
  filePath = "api/hikari"
  file = open(filePath, 'r')
  fileRead = file.read()
  return render_template("library.html", fileRead=fileRead)

@app.route('/hikari', methods=["GET"])
def hikari():
  return render_template("loader.html")

@app.route('/components/library', methods=["GET"])
def library():
  filePath = "api/hikari-components/library"
  fileOpen = open(filePath, 'r')
  fileRead = fileOpen.read()
  return Response(fileRead, content_type='text/plain')

@app.route('/components/library2', methods=["GET"])
def library2():
  filePath = "api/hikari-components/library2"
  fileOpen = open(filePath, 'r')
  fileRead = fileOpen.read()
  return Response(fileRead, content_type='text/plain')
  

@app.route("/games/bss", methods=["GET"])
def bss():
  filePath = "api/hikari-games/hikari[BSS]"
  fileOpen = open(filePath, 'r')
  fileRead = fileOpen.read()
  return Response(fileRead, content_type='text/plain')
  
@app.route("/games/makori", methods=["GET"])
def bss():
  filePath = "api/hikari-games/Makori"
  fileOpen = open(filePath, 'r')
  fileRead = fileOpen.read()
  return Response(fileRead, content_type='text/plain')