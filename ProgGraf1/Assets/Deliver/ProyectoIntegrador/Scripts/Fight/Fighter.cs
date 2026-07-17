using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Fighter : MonoBehaviour
{
   [SerializeField] private List<float> delays  = new List<float>(); 
   [SerializeField] private List<UnityEvent> events  = new List<UnityEvent>();

   [SerializeField] private ParticleSystem hitParticle;
   
   private int currentIndex;
   private Animator animator;

   private void Start()
   {
      animator = GetComponent<Animator>();
   }

   public void TriggerAnimation()
   {
      currentIndex++;

      StartCoroutine(DelayAnimation());
   }

   private IEnumerator DelayAnimation()
   {
      yield return new WaitForSeconds(delays[currentIndex]);
      animator.SetInteger("index", currentIndex);
      animator.SetTrigger("triggerAnim");
      events[currentIndex].Invoke();
      yield return new WaitForSeconds(0.8f);
      hitParticle.Play();
   }

}
