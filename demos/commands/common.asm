
;====================================
; HL *= DE
; Based on Z88DK runtime library
;====================================
Multiply:
		ld      b,16
		ld      a,h
		ld      c,l
		ld      hl,0
Multiply_Loop:
		add     hl,hl
		rl      c
		rla                  
		jr      nc, Multiply_Inner_Loop
		add     hl,de
Multiply_Inner_Loop:
		djnz    Multiply_Loop
		ret

;====================================
; hl = de/hl   de=de % hl
; Based on Z88DK runtime library
;====================================
Divide:
; Check for dividing by zero beforehand
		ld      a,h
		or      l
		ret     z
		ex      de,hl
;First have to obtain signs for quotient and remainder
		ld      a,h     ;dividend
		and     128
		ld      b,a     ;keep it safe
		jr      z,l_div0
;if -ve make into positive number!
		sub     a
		sub     l
		ld      l,a
		sbc     a,a
		sub     h
		ld      h,a
l_div0:
		ld      a,d     ;divisor
		and     128
		xor     b       
		ld      c,a     ;keep it safe (Quotient)
		bit     7,d
		jr      z,l_div01
		sub     a
		sub     e
		ld      e,a
		sbc     a,a
		sub     d
		ld      d,a
l_div01:
;Check for dividing by zero...
		ex      de,hl
		ld      a,h
		or      l
		ret     z       ;return hl=0, de=divisor
		ex      de,hl
		push    bc      ;keep the signs safe
;Now, we have two positive numbers so can do division no problems..
		ld      a,16    ;counter
		ld      b,h     ;arg1
		ld      c,l
		ld      hl,0    ;res1
; hl=res1 de=arg2 bc=arg1
		and     a
l_div1:
		rl      c       ;arg1 << 1 -> arg1
		rl      b
		rl      l       ;res1 << 1 -> res1
		rl      h
		sbc     hl,de   ;res1 - arg2 -> res1
		jr      nc,l_div2
		add     hl,de   ;res1 + arg2 -> res1
l_div2:
		ccf
		dec     a
		jr      nz,l_div1
		rl      c       ;arg1 << 1 -> arg1
		rl      b
;Have to return arg1 in hl and res1 in de
		ld      d,b
		ld      e,c
;Now do the signs..
		pop     bc      ;c holds quotient, b holds remainder
;de holds quotient, hl holds remainder
		ld      a,c
		call    dosign  ;quotient
		ld      a,b
		ex      de,hl   ;remainder (into de)
;Do the signs - de holds number to sign, a holds sign
dosign:
		and     128
		ret     z       ;not negative so okay..
		sub     a
		sub     e
		ld      e,a
		sbc     a,a
		sub     d
		ld      d,a
		ret

		
;====================================
; HL == DE
;====================================

CompareHLeqDE:
	; Check lower byte
	ld a, l
	cp e
	jr nz, SetHL_False
	
	; Check upper byte
	ld a, h
	cp d
	jr nz, SetHL_False

	ld hl,1
	ret

	
;====================================
; HL != DE
;====================================

CompareHLneqDE:
	; Compares for equality, then negates
	call CompareHLeqDE
	jr BooleanNotHL


;====================================
; HL = !HL
;====================================

BooleanNotHL:
	ld a, h
	or l
	jr nz, SetHL_False	; If it's non-zero, set HL to false
	ld hl, 1			; If it's zero, set HL to true
	ret

	
;====================================
; DE < HL
;====================================

CompareDEltHL:
	call CompareDE_HL
	jr nc, SetHL_False	; If no carry, DE >= HL
	ld hl, 1			; If carry, DE < HL
	ret

	
;====================================
; DE <= HL
;====================================

CompareDElteHL:
	; Compares for '>', then negates
	call CompareDEgtHL
	jr BooleanNotHL

	
;====================================
; DE > HL
;====================================

CompareDEgtHL:
	; Just swaps the arguments, then compares for '<'
	ex de,hl
	jr CompareDEltHL


;====================================
; DE > HL
;====================================

CompareDEgteHL:
	; Compares for '<', then negates
	call CompareDEltHL
	jr BooleanNotHL

	
;====================================
; HL = false
;====================================

SetHL_False:
	ld hl, 0
	ret


;================================================
; Compares de with hl
; Taken from Z88DK
; signed compare of DE and HL
;   carry is sign of difference 
;          [set => DE < HL]
;   zero is zero/non-zero
;================================================

CompareDE_HL:
	ld	a, h
	add	a, $80
	ld	b,a
	ld	a,d
	add	a, $80
	cp	b
	jp	nz, CompareDE_HL_done
	ld	a, e
	cp	l
CompareDE_HL_done:
	ret
