public class CalculatorController {
	
    public Decimal firstNumber {get;set;}
    public decimal secondNumber {get;set;}
    public decimal result {get;set;}
    
    public void sum(){
        result = firstNumber + secondNumber;
    }
    
    public void subtract(){
        result = firstNumber - secondNumber;
    }
    
    public void multiply(){
        result = firstNumber * secondNumber;
    }
    
    
}