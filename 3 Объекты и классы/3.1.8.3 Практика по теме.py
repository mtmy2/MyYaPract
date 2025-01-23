class CipherMaster:
    alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
    
    def cipher(self, original_text, shift):
        # Метод должен возвращать зашифрованный текст 
        # с учетом переданного смещения shift.
        self.original_text = str.lower(original_text)
        self.shift = shift
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

    
    
    def decipher(self, cipher_text, shift):
        # Метод должен возвращать исходный текст
        # с учётом переданного смещения shift.
        pass


cipher_master = CipherMaster()
print(cipher_master.cipher(
    original_text='Однажды ревьюер принял проект с первого раза, с тех пор я его боюсь',
    shift=2
))
print(cipher_master.decipher(
    cipher_text='Олебэи яфвнэ мроплж сэжи — э пэй рдв злййвкпш лп нвящывнэ',
    shift=-3
))