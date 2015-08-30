/mob/living/carbon/alien/diona/verb/evolve()

	set name = "Evolve"
	set desc = "Evolve into your adult form."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return
		
	var/adult_form = get_adult_form()

	if(!adult_form)
		verbs -= /mob/living/carbon/alien/verb/evolve
		return

	if(handcuffed || legcuffed)
		src << "\red You cannot evolve when you are cuffed."
		return

	if(amount_grown < max_grown)
		src << "\red You are not fully grown."
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	var/mob/living/carbon/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)
	show_evolution_blurb()

	if(mind)
		mind.transfer_to(adult)
	else
		adult.key = src.key

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)
	del(src)

/mob/living/carbon/alien/diona/proc/confirm_evolution()

	if(!is_alien_whitelisted(src, "Diona") && config.usealienwhitelist)
		src << alert("You are currently not whitelisted to play as a full diona.")
		return null

	if(amount_grown < max_grown)
		src << "You are not yet ready for your growth..."
		return null

	src.split()

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.loc = L.loc
		del(L)

	src.visible_message("\red [src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.","\red You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.")
	return "Diona"

/mob/living/carbon/alien/diona/proc/show_evolution_blurb()
	//TODO
	return

/mob/living/carbon/alien/diona/proc/update_progression()

	amount_grown = donors.len

	if(amount_grown <= last_checked_stage)
		return

	// Only fire off these messages once.
	last_checked_stage = amount_grown
	if(amount_grown == max_grown)
		src << "\green You feel ready to move on to your next stage of growth."
	else if(amount_grown == 3)
		universal_understand = 1
		src << "\green You feel your awareness expand, and realize you know how to understand the creatures around you."
	else
		src << "\green The blood seeps into your small form, and you draw out the echoes of memories and personality from it, working them into your budding mind."