class CipherMaster:
    alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
    
    def process_text(self, text, shift, is_encrypt):
        # Метод должен возвращать зашифрованный текст 
        # с учетом переданного смещения shift.
        self.original_text = str.lower(text)
        self.shift = shift if is_encrypt else -shift
        self.new_text = ''
        for index, current_original_letter in enumerate(self.original_text):
            if str.find(self.alphabet, current_original_letter)>=0:
                if str.find(self.alphabet, current_original_letter)+self.shift > 32:
                    self.new_letter_index = str.find(self.alphabet, current_original_letter)+self.shift - 33
                else:
                    self.new_letter_index = str.find(self.alphabet, current_original_letter)+self.shift
                self.new_letter = self.alphabet[self.new_letter_index]
                self.new_text = f'{self.new_text}{self.new_letter}'
            else:
                self.new_text = f'{self.new_text}{current_original_letter}'        
        return self.new_text   


# Проверка:
cipher_master = CipherMaster()
print(cipher_master.process_text(
    text='Однажды ревьюер принял проект с первого раза, с тех пор я его боюсь',
    shift=2,
    is_encrypt=True
))
print(cipher_master.process_text(
    text='Олебэи яфвнэ мроплж сэжи — э пэй рдв злййвкпш лп нвящывнэ',
    shift=-3,
    is_encrypt=False
)) 