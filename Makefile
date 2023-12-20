all:
	love ./

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/secret-santa-2023-lovejs.zip" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/secret-santa-2023/"
	python3 -m http.server
