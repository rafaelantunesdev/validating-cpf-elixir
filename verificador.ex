defmodule VerificaCPF do

  def verificar(cpf) do
    cpf
    |> stringHandler()
    |> validateCPF()
  end


  # String Handling #

  def stringHandler(string) do
    string
    |> remove_non_numbers()
    |> split_into_chars()
    |> transform_string_into_integer()
    |> split_cpf()
  end

  
  def remove_non_numbers(string), do: String.replace(string, [".", "-"], "")
  def split_into_chars(string), do: String.split(string, "", trim: true)
  def transform_string_into_integer(string), do: Enum.map(string, fn int_string -> String.to_integer(int_string) end)
  def split_cpf(cpf), do: Enum.chunk_every(cpf, 9)

  # ________________ #


  # Calculate the sum of the CPF digits #

  def calcularSomatorio(numeros, multiplier_start) do
    {somatorio, _} =
      Enum.reduce(numeros, {0, multiplier_start}, fn x, {acc_sum, acc_multiplicador} ->
        {x * acc_multiplicador + acc_sum, acc_multiplicador - 1}
      end)
      somatorio # Return the sum
  end

  # ________________ #


  # Calculate the two last digits #

  def validateCPF([numeros, digitos_a_verificar]) do
    # Calculate the first of the two last digits
    primeiroDigito = calcularSomatorio(numeros, 10) |> calcularUltimoDigito()

    # Append "primeiroDigito" to the list "numeros" than calculate the last CPF digit
    numeros = List.insert_at(numeros, 10, primeiroDigito)
    segundoDigito = calcularSomatorio(numeros, 11) |> calcularUltimoDigito()

    # Store both digits in a list
    digitos = [primeiroDigito, segundoDigito]
    validarDigitos(digitos, digitos_a_verificar)
  end

    # Calculate the rem of somatorio/11     
    def calcularUltimoDigito(somatorio) do
      case rem(somatorio, 11) do
        1 -> 0 # If it's 1 or 0 > returns 0 (the digit is 0)
        0 -> 0
        _ -> calculaResto(somatorio) # If it's any other number, pass the "somatorio" value to the calculaResto function, so we can find the digit.
    end
  end

    # This function is calculating the digit and returning to the validateCPF fun.
    def calculaResto(soma) do
      soma = rem(soma, 11)
      _soma = 11 - soma
    end
  # ________________ #


  # Validating the CPF #

  def validarDigitos(novosDigitos, inputUsuario) do # Comparing the calculated digits with the user input.
    case novosDigitos == inputUsuario do
    true -> true # If it matches, return true. (The CPF is valid)
    false -> false # If it does not match, return false. (THE CPF is not valid)
    end
  end

  # ________________ #

end # End of the Module