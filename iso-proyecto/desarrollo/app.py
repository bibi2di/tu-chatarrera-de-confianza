from flask import Flask, request, render_template
import os
import re
app = Flask(__name__)
@app.route('/')
def index():
   return render_template('index.html')

@app.route('/app.py/guardar/',methods=['POST','GET'])
def guardar():
   if request.method == 'POST':
       telefono = request.form['telefono']
       nombre = request.form['nombre']
       apellido = request.form['apellido']
   else:
       telefono = request.args.get('telefono')
       nombre = request.args.get('nombre')
       apellido = request.args.get('apellido')
   # Abrimos el fichero
   with open("datos_guardados.txt", "r+") as fichero:
       encontrado = False
       for linea in fichero:
           #re.findall it returns a list of strings containing all matches
           telf=re.findall('[0-9]+', linea)
           if telefono in telf:
               encontrado=True
               break
       if encontrado==False:
           fichero.seek(0, os.SEEK_END)
           fichero.write(telefono+"\t"+nombre+"\t"+apellido+"\n")
           # Cerramos el fichero
           fichero.close()
           return render_template('resultado.html',nombre=nombre,apellido=apellido)
   
       else:
           fichero.close()
           return render_template('resultado2.html')


if __name__=='__main__':
   app.run(debug=True,host='0.0.0.0')

