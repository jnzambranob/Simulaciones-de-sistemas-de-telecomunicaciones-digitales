function y = cdmademod(msg)

mwalsh=hadamard(8);

for i=1:8:length(msg)
    out(i)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(1,:)));
    out(i+1)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(5,:)));
    out(i+2)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(3,:)));
    out(i+3)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(7,:)));
    out(i+4)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(2,:)));
    out(i+5)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(6,:)));
    out(i+6)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(4,:)));
    out(i+7)=sign(sum(msg([i 1+i 2+i 3+i 4+i 5+i 6+i 7+i]).*mwalsh(8,:)));
end

y=out;
