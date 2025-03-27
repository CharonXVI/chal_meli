from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects


class conector_api:

    @staticmethod
    def abrir_sesion():
        """Inicializa el metodo de session
        """
        try:
            return Session()
        except Exception as e:
            raise
    @staticmethod
    def actualizar_headers(headers):
        """recibe los headers y y updatea la sesion
        """
        session=conector_api.abrir_sesion()
        session.headers.update(headers)
        return session
    @staticmethod
    def obtener_datos(url,headers,parametros):
        """Recibe los parametros y la url y obtiene una respuesta
        """
        try:
            session=conector_api.actualizar_headers(headers)
            response=session.get(url, params=parametros)
            return response
        except (ConnectionError, Timeout, TooManyRedirects) as e:
            raise
    
        
# session = Session()
# session.headers.update(headers)

# try:
#   response = session.get(url, params=parameters)
#   data = json.loads(response.text)
#   print(data)
# except (ConnectionError, Timeout, TooManyRedirects) as e:
#   print(e)