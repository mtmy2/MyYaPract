
def valid_mountain_array(data):
    peak_count = 0
    delta_list = [None]*len(data)
    if len(data) < 3:
        return False
    for i in range(len(data)):
        data[i] = int(data[i])
    data.append(int(data[len(data)-1])-1)
    for i in range(len(data)-1):
        if i == 0:
            pass
        else:    
            if data[i-1] > data[i] < data[i+1] or data[i] == data[i-1]:
                 return False
            elif data[i-1] < data[i] > data[i+1] and i != len(data)-2:
                peak_count += 1
    if peak_count == 1:
        return True
    else:
        return False
    
data = ['1', '2', '3', '4', '5']
#data = input().split()
#print(int(data))    
answer = valid_mountain_array(data)
print(str(answer)) 
#print(' '.join(data))

#with open('output.txt', 'w') as file_out:
#        file_out.write(answer)