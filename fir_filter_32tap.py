import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal

N1 = 10  # Bit width for filter coefficients

N2 = 16  # Bit width for input signal

N3 = 32  # Bit width for output signal

scale_factor = 2 ** (N1 - 1)  # Scale factor for converting to binary representation

# 1. 랜덤 시드 고정 (매 실행마다 동일한 노이즈 생성)
np.random.seed(42)

# This function is used to perform a signed binary to the signed decimal representation
def todecimal(x, bits):
    assert len(x) <= bits, "Input binary string length does not match specified bit width."
    n = int(x,2)
    s = 1 << (bits - 1)
    return (n&(s-1)) - (n&s)

#generate a test noisy harmonic signal
Fs = 1000  # Sampling frequency
dt = 1/Fs  # Time step
t = np.arange(0,1,dt)  # Time vector
output = 2 * np.sin(2 * np.pi * 50 * t) + np.cos(2 * np.pi * 120 * t) + np.random.randn(len(t)) * 0.3  # Noisy harmonic signal

#FFT of the signal
fft_output = np.fft.fft(output)

fft_magnitude = 2*np.abs(fft_output)/len(output)
fft_freq = np.fft.fftfreq(len(output), dt)

phase = np.angle(fft_output)  # Phase of the FFT output
threshold = 0.1  # Threshold for filtering
phase_thresholded = np.where(fft_magnitude > threshold, phase, 0)  # Filtered phase based on magnitude threshold

# Plot the original signal and its FFT
plt.figure(figsize=(12, 6))
plt.subplot(3,1,1)
plt.plot(t, output)
plt.title('Original Noisy Harmonic Signal')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')

plt.subplot(3,1,2)
plt.plot(fft_freq, fft_magnitude)
plt.title('FFT of the Signal')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Magnitude')
plt.xlim(0, Fs/2)  # Limit x-axis to positive frequencies

plt.subplot(3,1,3)
plt.plot(fft_freq, np.rad2deg(phase_thresholded))
plt.title('Phase of the Signal')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Phase [degrees]')
plt.xlim(0, Fs/2)  # Limit x-axis to positive frequencies


plt.tight_layout() # 화면의 레이아웃을 조정하여 겹치지 않도록 함
plt.show()

#save the converted sequence to the data file

#convert to binary
output_b = []
for number in output:
    output_b.append(np.binary_repr(int(number * scale_factor), width=N2))

#save the converted sequence to the data file
with open('input2.data', 'w') as f:
    for item in output_b:
        f.write(f"{item}\n")

#design fir filter

#number of taps
numtaps = 32
cutoff_freq = 150

#design the filter using the window method
fir_coeff = signal.firwin(numtaps, cutoff_freq, fs=Fs, window = 'hamming')

#plot the filter coefficients
plt.stem(fir_coeff)
plt.xlabel('Filter Coefficient Index')
plt.ylabel('Amplitude')
plt.title('FIR Filter Coefficients')
plt.show()

#calculate the frequency response of the filter
w, h = signal.freqz(fir_coeff, worN=8000)

#convert virtual frequency to actual frequency
freqencies = w * Fs / (2 * np.pi)

#magintiude response, phase response
amplitude = np.abs(h) # magnitude
amplitude_db = 20*np.log10(np.abs(h)) #dB
phase = np.rad2deg(np.unwrap(np.angle(h)))


plt.figure(figsize=(12, 6))
plt.subplot(3, 1, 1)
plt.plot(freqencies, amplitude_db)
plt.title('Frequency Response of FIR Filter')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Magnitude [dB]')
plt.xlim(0, Fs/2)

plt.subplot(3, 1, 2)
plt.plot(freqencies, phase)
plt.title('Phase Response of FIR Filter')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Phase [degrees]')
plt.xlim(0, Fs/2)

plt.subplot(3, 1, 3)
plt.plot(freqencies, amplitude)
plt.title('Magnitude Response of FIR Filter')
plt.xlabel('Frequency [Hz]')
plt.ylabel('Magnitude')
plt.xlim(0, Fs/2)

plt.tight_layout()
plt.show()

#filtered output using the designed FIR filter
filtered_output = signal.lfilter(fir_coeff, 1.0, output)

plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
plt.plot(t, output, label='Original Signal')
plt.title('Original Noisy Harmonic Signal')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.xlim(0, t[-1]/4)  # Limit x-axis to the first half of the time vector

plt.subplot(2, 1, 2)
plt.plot(t, filtered_output, label='Filtered Signal', color='orange')
plt.title('Filtered Signal using FIR Filter')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.tight_layout()
plt.xlim(0, t[-1]/4)  # Limit x-axis to the first half of the time vector
plt.show()

#save the filter coefficients to a file
#convert the filter coefficients to binary representation
fir_coeff_b = []
for coeff in fir_coeff:
    fir_coeff_b.append(np.binary_repr(int(coeff * scale_factor), width=N1))


with open('fir_coefficients.data', 'w') as f:
    for coeff in fir_coeff_b:
        f.write(f"{coeff}\n")

