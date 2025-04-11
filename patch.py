
from flask import send_file

@app.route('/static/<int:post_id>.webp')
def static_image(post_id):
    return send_file(f'images/{post_id}.webp')
