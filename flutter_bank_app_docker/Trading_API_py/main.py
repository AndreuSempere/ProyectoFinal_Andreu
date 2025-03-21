from fastapi import FastAPI
import yfinance as yf
import logging
import time
import requests
import os
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Configurar session con reintentos para yfinance
session = requests.Session()
retry = Retry(
    total=10,
    backoff_factor=1.0,
    status_forcelist=[429, 500, 502, 503, 504],
    allowed_methods=["HEAD", "GET", "OPTIONS"]
)
adapter = HTTPAdapter(max_retries=retry)
session.mount("http://", adapter)
session.mount("https://", adapter)
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive',
    'Upgrade-Insecure-Requests': '1',
    'Cache-Control': 'max-age=0'
})

# Listas de activos con sus símbolos
STOCKS = {
    "tesla": "TSLA",
    "nvidia": "NVDA",
    "apple": "AAPL",
    "microsoft": "MSFT",
    "google": "GOOGL"
}

CRYPTO = {
    "bitcoin": "BTC-USD",
    "ethereum": "ETH-USD",
    "solana": "SOL-USD",
    "xrp": "XRP-USD",
    "cardano": "ADA-USD"
}

COMMODITIES = {
    "oro": "GC=F",
    "plata": "SI=F",
    "petroleo": "CL=F",
    "gas_natural": "NG=F",
    "cobre": "HG=F"
}

# Datos de fallback
FALLBACK_DATA = {
    "TSLA": {"price": 310.45, "date": "2025-03-16"},
    "NVDA": {"price": 975.60, "date": "2025-03-16"},
    "AAPL": {"price": 190.75, "date": "2025-03-16"},
    "MSFT": {"price": 432.80, "date": "2025-03-16"},
    "GOOGL": {"price": 180.40, "date": "2025-03-16"},
    "BTC-USD": {"price": 64500.75, "date": "2025-03-16"},
    "ETH-USD": {"price": 3580.90, "date": "2025-03-16"},
    "SOL-USD": {"price": 135.20, "date": "2025-03-16"},
    "XRP-USD": {"price": 0.58, "date": "2025-03-16"},
    "ADA-USD": {"price": 0.48, "date": "2025-03-16"},
    "GC=F": {"price": 2205.80, "date": "2025-03-16"},
    "SI=F": {"price": 25.90, "date": "2025-03-16"},
    "CL=F": {"price": 80.15, "date": "2025-03-16"},
    "NG=F": {"price": 2.05, "date": "2025-03-16"},
    "HG=F": {"price": 4.40, "date": "2025-03-16"}
}


@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API de mercado financiero"}

@app.get("/test-connection")
def test_connection():
    results = {}
    # Probar Google
    try:
        response = requests.get("https://www.google.com", timeout=5)
        results["google"] = {
            "status": response.status_code,
            "success": response.status_code == 200
        }
    except Exception as e:
        results["google"] = {"error": str(e), "success": False}
    
    # Probar Yahoo
    try:
        response = requests.get("https://finance.yahoo.com", timeout=5)
        results["yahoo_finance_web"] = {
            "status": response.status_code,
            "success": response.status_code == 200
        }
    except Exception as e:
        results["yahoo_finance_web"] = {"error": str(e), "success": False}
    
    # Probar API de Yahoo Finance
    try:
        response = requests.get("https://query1.finance.yahoo.com/v8/finance/chart/AAPL?interval=1d&range=1d", timeout=5)
        results["yahoo_finance_api"] = {
            "status": response.status_code,
            "success": response.status_code == 200
        }
    except Exception as e:
        results["yahoo_finance_api"] = {"error": str(e), "success": False}
    
    # Información del sistema
    results["system_info"] = {
        "dns_servers": "Ver en /etc/resolv.conf",
        "environment": {k: v for k, v in os.environ.items() if k in ["PYTHONHTTPSVERIFY", "HTTP_PROXY", "HTTPS_PROXY"]}
    }
    
    return results

def get_yahoo_direct(symbol: str):
    try:
        logger.info(f"Intentando obtener datos directamente de Yahoo Finance para {symbol}")
        
        url = f"https://query1.finance.yahoo.com/v8/finance/chart/{symbol}?interval=1d&range=1d"
        
        response = session.get(url, timeout=10)
        
        if response.status_code != 200:
            logger.warning(f"Error en solicitud directa a Yahoo Finance para {symbol}: {response.status_code}")
            return None, None
            
        data = response.json()
        
        # Verificar si hay datos en la respuesta
        if not data or "chart" not in data or "result" not in data["chart"] or not data["chart"]["result"]:
            logger.warning(f"No hay datos en la respuesta directa de Yahoo Finance para {symbol}")
            return None, None
            
        result = data["chart"]["result"][0]
        
        # Obtener el último precio
        if "meta" in result and "regularMarketPrice" in result["meta"]:
            price = result["meta"]["regularMarketPrice"]
            
            # Obtener la fecha
            if "timestamp" in result and result["timestamp"]:
                timestamp = result["timestamp"][-1]
                date_str = time.strftime('%Y-%m-%d', time.localtime(timestamp))
                
                logger.info(f"{symbol}: Precio {price} en fecha {date_str} (método directo)")
                return round(price, 2), date_str
                
    except Exception as e:
        logger.error(f"Error en solicitud directa a Yahoo Finance para {symbol}: {str(e)}")
        
    return None, None

def get_price(symbol: str):
    logger.info(f"Intentando obtener datos para {symbol}")

    # Intentar obtener datos de Yahoo directamente
    price, date = get_yahoo_direct(symbol)
    if price is not None:
        logger.info(f"Datos obtenidos de Yahoo Directo: {price} en {date}")
        return price, date

    # Intentar con yfinance
    try:
        stock = yf.Ticker(symbol)
        data = stock.history(period="1d")
        if not data.empty:
            last_date = data.index[-1].strftime('%Y-%m-%d')
            last_price = round(data["Close"].iloc[-1], 2)
            logger.info(f"Datos obtenidos de yfinance: {last_price} en {last_date}")
            return last_price, last_date
    except Exception as e:
        logger.error(f"Error al obtener datos con yfinance para {symbol}: {str(e)}")

    logger.warning(f"Falling back a datos predefinidos para {symbol}")
    return FALLBACK_DATA.get(symbol, {"price": None, "date": None})["price"], FALLBACK_DATA.get(symbol, {"price": None, "date": None})["date"]


@app.get("/all")
def get_all_prices():
    all_data = {
        "stocks": [],
        "crypto": [],
        "commodities": []
    }
    
    # Añadir stocks
    for name, symbol in STOCKS.items():
        price, date = get_price(symbol)
        if price is not None:
            all_data["stocks"].append({
                "name": name.capitalize(),
                "symbol": symbol,
                "price": price,
                "last_updated": date
            })
    
    # Añadir crypto
    for name, symbol in CRYPTO.items():
        price, date = get_price(symbol)
        if price is not None:
            all_data["crypto"].append({
                "name": name.capitalize(),
                "symbol": symbol,
                "price": price,
                "last_updated": date
            })
    
    # Añadir commodities
    for name, symbol in COMMODITIES.items():
        price, date = get_price(symbol)
        if price is not None:
            all_data["commodities"].append({
                "name": name.capitalize(),
                "symbol": symbol,
                "price": price,
                "last_updated": date
            })
    
    return all_data
