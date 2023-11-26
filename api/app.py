from flask import Flask, render_template, request, redirect, url_for, g, flash, abort, jsonify, send_file, make_response
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

@app.route('/')
def home():
  file = "Hikari.lua"
  
  return send_file(file, mimetype="text/plain")
  
@app.route('components/library')
def library():
  file = "Hikari[Components]/Library.lua"
  
  return send_file(file, mimetype="text/plain")