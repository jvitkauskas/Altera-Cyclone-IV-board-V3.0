module half_adder(
    A,					//输入选择地址由开关决定，0：按下，1：未按下
	B,					//输入选择地址由开关决定，0：按下，1：未按下
	
	S,					//输出，0：点亮，1：熄灭
	C					//输出，0：点亮，1：熄灭
    );
input			A;			//输入端口
input			B;			//输入端口

output		S;			//输出端口
output		C;			//输出端口

assign S = A ^ B;				//直接赋值，异或
assign C = A & B;			//直接赋值，与

endmodule
