import os
from app import create_app

app = create_app()

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', 'True').lower() in ['true', '1', 't']
    print("=" * 60)
    print(" FitTrack – Health & Fitness Tracking Platform")
    print(f" Server running at: http://127.0.0.1:{port}/")
    print("=" * 60)
    app.run(host='0.0.0.0', port=port, debug=debug)
