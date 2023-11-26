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
  file = "Hikari.lua"
  
  return send_file(file, mimetype="text/plain")
  
@app.route('/components/library', methods=["GET"])
def library():
  filePath = "Components/Library.lua"
  
  file = open(filePath, 'r')
  
  response = Response(file.read(), content_type='text/plain')
  
  return response