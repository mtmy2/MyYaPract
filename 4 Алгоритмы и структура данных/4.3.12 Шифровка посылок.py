from random import choice
class MarsURLEncoder:

    def __init__(self):
        self.url_storage = {}
        pass


    def encode(self, long_url):
        """Кодирует длинную ссылку в короткую вида https://ma.rs/X7NYIol."""
        hash = choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)
        if hash in self.url_storage:
            hash = choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)+choice(long_url)
        self.url_storage[hash] = long_url
        return f'https://ma.rs/{hash}'

    def decode(self, short_url):
        """Декодирует короткую ссылку вида https://ma.rs/X7NYIol в исходную."""
        hash = str.split(short_url, '.rs/')[1]
        long_url = self.url_storage[hash]
        return long_url


url = 'https://tsup.ru/mars/marsohod-1/01-09-2023/daily_job.html'
#hash = choice(url)+choice(url)+choice(url)+choice(url)+choice(url)+choice(url)
url_make = MarsURLEncoder()
hash = str.split(url_make.encode(url), '.rs/')[1]
long_url = url_make.decode(f'https://ma.rs/{hash}')
print(hash)
print(long_url)
# url_make.url_storage[0]