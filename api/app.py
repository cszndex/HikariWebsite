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
  response = Response(file.read(), content_type='text/plain')
  
  return response

@app.route('/components/library', methods=["GET"])
def library():
  filePath = "api/hikari-component/library"
  file = open(filePath, 'r')
  response = Response(file.read(), content_type='text/plain')
  
  return response